#!/usr/bin/env python3
"""Explicit dotfiles update orchestration.

This module contains the testable implementation used by the installed
``update`` wrapper.  Chezmoi itself remains responsible only for rendering and
applying files.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import IO, Iterable, Mapping, NamedTuple, Optional, Sequence


VALID_PROFILES = ("home", "work")
SECTION_ORDER = ("tap", "brew", "cask", "mas", "krew")
ALLOWED_ATTACHMENTS = frozenset(("gitconfig", "secrets.zsh"))
SKILLS_VERSION = "1.5.23"


class UpdateError(RuntimeError):
    """A required update stage failed."""


class OptionalStageError(UpdateError):
    """An optional stage could not be completed."""


class AggregateUpdateError(UpdateError):
    """One or more independent stages failed."""


class CommandResult(NamedTuple):
    command: list[str]
    returncode: int
    stdout: str
    stderr: str


class CommandRunner:
    """Run commands and retain their complete results for diagnostics."""

    def __init__(self, dry_run: bool = False, env: Optional[Mapping[str, str]] = None):
        self.dry_run = dry_run
        self.env = dict(env or os.environ)
        self.commands: list[list[str]] = []
        self.results: list[CommandResult] = []

    def run(
        self,
        command: Sequence[object],
        *,
        env: Optional[Mapping[str, str]] = None,
        input_text: Optional[str] = None,
        cwd: Optional[Path] = None,
        stdin: Optional[IO[str]] = None,
    ) -> CommandResult:
        normalized = [str(part) for part in command]
        self.commands.append(normalized)
        if self.dry_run:
            print("DRY-RUN:", " ".join(normalized))
            result = CommandResult(normalized, 0, "", "")
            self.results.append(result)
            return result

        process = subprocess.run(
            normalized,
            capture_output=True,
            text=True,
            input=input_text,
            stdin=stdin,
            cwd=str(cwd) if cwd else None,
            env=dict(env or self.env),
            check=False,
        )
        result = CommandResult(normalized, process.returncode, process.stdout, process.stderr)
        self.results.append(result)
        return result


def require_success(result: CommandResult, operation: str) -> CommandResult:
    if result.returncode:
        details = result.stderr.strip() or result.stdout.strip()
        suffix = f": {details}" if details else ""
        raise UpdateError(f"{operation} failed with exit code {result.returncode}{suffix}")
    return result


def validate_profile(profile: str) -> str:
    if profile not in VALID_PROFILES:
        raise ValueError("profile must be home or work")
    return profile


def inspect_restic_config(path: Path) -> tuple[Optional[str], bool, bool]:
    """Return a doctor failure, HTTP state, and root-protection state."""

    try:
        if not path.is_file():
            return "Restic repository configuration", False, False
        contents = path.read_text(encoding="utf-8")
    except PermissionError:
        return None, False, True
    except OSError:
        return "readable Restic repository configuration", False, False

    repository_line = next(
        (line for line in contents.splitlines() if line.startswith("RESTIC_REPOSITORY=")),
        "",
    )
    if not repository_line:
        return "Restic repository URL", False, False
    return None, "http://" in repository_line, False


def build_mise_environment(
    environment: Mapping[str, str], config_file: Path
) -> dict[str, str]:
    """Build an environment that works with mise outside an activated shell."""

    result = dict(environment)
    shims = str(Path.home() / ".local" / "share" / "mise" / "shims")
    existing_path = result.get("PATH", "")
    path_entries = [entry for entry in existing_path.split(os.pathsep) if entry and entry != shims]
    result["PATH"] = os.pathsep.join((shims, *path_entries))
    result["MISE_GLOBAL_CONFIG_FILE"] = str(config_file)
    return result


def _strip_comment(line: str) -> str:
    """Remove Brewfile comments while preserving # inside quoted values."""

    quote: Optional[str] = None
    escaped = False
    for index, character in enumerate(line):
        if escaped:
            escaped = False
            continue
        if character == "\\" and quote:
            escaped = True
            continue
        if character in ("'", '"'):
            quote = None if quote == character else character if quote is None else quote
            continue
        if character == "#" and quote is None:
            return line[:index].rstrip()
    return line.rstrip()


def _directive_kind(line: str) -> Optional[str]:
    match = re.match(r"^([a-z]+)\s+", line)
    return match.group(1) if match and match.group(1) in SECTION_ORDER else None


def merged_brewfile_contents(base_dir: Path, profile: str) -> str:
    """Return merged Brewfile contents without changing the filesystem."""
    validate_profile(profile)
    base = Path(base_dir).expanduser().resolve()
    sources = (base / "Brewfile.common", base / f"Brewfile.{profile}")
    for source in sources:
        if not source.is_file():
            raise FileNotFoundError(f"required Brewfile is missing: {source.name}")

    directives: dict[str, list[str]] = {kind: [] for kind in SECTION_ORDER}
    seen: set[str] = set()
    for source in sources:
        for raw_line in source.read_text(encoding="utf-8").splitlines():
            line = _strip_comment(raw_line).strip()
            if not line or line in seen:
                continue
            kind = _directive_kind(line)
            if kind is None:
                raise UpdateError(f"unsupported Brewfile directive in {source.name}: {line}")
            seen.add(line)
            directives[kind].append(line)

    lines = [f"# Generated from Brewfile.common and Brewfile.{profile}"]
    for kind in SECTION_ORDER:
        lines.extend(directives[kind])
    return "\n".join(lines) + "\n"


def build_merged_brewfile(base_dir: Path, profile: str) -> Path:
    """Build a secure named temporary Brewfile."""

    contents = merged_brewfile_contents(base_dir, profile)
    handle = tempfile.NamedTemporaryFile(
        mode="w",
        encoding="utf-8",
        prefix=f"dotfiles-{profile}-",
        suffix=".Brewfile",
        delete=False,
    )
    try:
        with handle:
            handle.write(contents)
        return Path(handle.name)
    except BaseException:
        Path(handle.name).unlink(missing_ok=True)
        raise


def is_allowed_attachment(name: object) -> bool:
    if not isinstance(name, str) or name not in ALLOWED_ATTACHMENTS:
        return False
    path = Path(name)
    return not path.is_absolute() and path.name == name and name not in (".", "..")


def parse_pinned_github_source(source: str) -> tuple[str, str]:
    match = re.fullmatch(
        r"(https://github\.com/[^/]+/[^/]+?)(?:\.git)?/tree/([0-9a-f]{40})",
        source,
    )
    if not match:
        raise UpdateError(f"external skill source is not commit-pinned: {source}")
    return f"{match.group(1)}.git", match.group(2)


def _optional_result(result: CommandResult, operation: str) -> CommandResult:
    if result.returncode:
        details = result.stderr.strip() or result.stdout.strip()
        raise OptionalStageError(f"{operation} failed{': ' + details if details else ''}")
    return result


def fetch_secrets(
    profile: str,
    runner: CommandRunner,
    target_dir: Path,
    environment: Mapping[str, str],
    *,
    tty_available: Optional[bool] = None,
) -> None:
    """Atomically retrieve the two allowlisted Bitwarden attachments."""

    validate_profile(profile)
    dry_run = bool(getattr(runner, "dry_run", False))
    if isinstance(runner, CommandRunner) and not dry_run and shutil.which("bw") is None:
        raise OptionalStageError("Bitwarden CLI is unavailable; skipping secrets")

    env = dict(environment)
    managed_session = False
    try:
        if not env.get("BW_SESSION"):
            if tty_available is None:
                tty_available = os.path.exists("/dev/tty")
            if not tty_available:
                raise OptionalStageError("Bitwarden is locked and no TTY is available; skipping secrets")
            check = runner.run(["bw", "login", "--check"], env=env)
            auth = ["bw", "unlock", "--raw"] if check.returncode == 0 else ["bw", "login", "--raw"]
            tty: Optional[IO[str]] = None
            try:
                if isinstance(runner, CommandRunner):
                    try:
                        tty = open("/dev/tty", "r", encoding="utf-8")
                    except OSError as error:
                        raise OptionalStageError(
                            "Bitwarden authentication requires an interactive TTY; skipping secrets"
                        ) from error
                result = _optional_result(
                    runner.run(auth, env=env, stdin=tty),
                    "Bitwarden authentication",
                )
            finally:
                if tty is not None:
                    tty.close()
            session = result.stdout.strip()
            if not session:
                raise OptionalStageError("Bitwarden returned an empty session")
            env["BW_SESSION"] = session
            managed_session = True

        _optional_result(runner.run(["bw", "sync"], env=env), "Bitwarden sync")
        item_result = _optional_result(
            runner.run(["bw", "get", "item", f"_chezmoi_{profile}"], env=env),
            "Bitwarden item lookup",
        )
        try:
            item = json.loads(item_result.stdout)
            item_id = str(item["id"])
        except (KeyError, TypeError, ValueError) as error:
            raise OptionalStageError(f"invalid Bitwarden item response: {error}") from error

        attachments = item.get("attachments", [])
        rejected = [
            attachment.get("fileName")
            for attachment in attachments
            if not is_allowed_attachment(attachment.get("fileName"))
        ]
        if rejected:
            raise OptionalStageError(
                "Bitwarden item contains unsafe or unknown attachments: "
                + ", ".join(repr(name) for name in rejected)
            )

        target = Path(target_dir).expanduser()
        if not dry_run:
            target.mkdir(parents=True, exist_ok=True, mode=0o700)
            target.chmod(0o700)

        staged: list[tuple[Path, Path]] = []
        try:
            for attachment in attachments:
                name = attachment.get("fileName")
                attachment_id = str(attachment.get("id", ""))
                if not attachment_id:
                    raise OptionalStageError(f"Bitwarden attachment {name} has no id")

                if dry_run:
                    temporary = target / f".{name}.temporary"
                else:
                    descriptor, temporary_name = tempfile.mkstemp(prefix=f".{name}.", dir=target)
                    os.close(descriptor)
                    temporary = Path(temporary_name)
                staged.append((temporary, target / name))
                result = runner.run(
                    [
                        "bw",
                        "get",
                        "attachment",
                        attachment_id,
                        "--itemid",
                        item_id,
                        "--output",
                        temporary,
                    ],
                    env=env,
                )
                _optional_result(result, f"download of {name}")
                if not dry_run:
                    temporary.chmod(0o600)

            if not dry_run:
                for temporary, destination in staged:
                    os.replace(temporary, destination)
                    destination.chmod(0o600)
        finally:
            if not dry_run:
                for temporary, _ in staged:
                    temporary.unlink(missing_ok=True)
    finally:
        if managed_session:
            runner.run(["bw", "lock"], env=env)


class UpdateManager:
    """Explicit implementations for each public update command."""

    def __init__(
        self,
        profile: str,
        runner: CommandRunner,
        *,
        extras_dir: Optional[Path] = None,
        secrets_dir: Optional[Path] = None,
        assume_yes: bool = False,
        zap: bool = False,
    ):
        self.profile = validate_profile(profile)
        self.runner = runner
        self.extras_dir = Path(extras_dir or Path(__file__).resolve().parent)
        self.source_dir = self.extras_dir.parent
        self.secrets_dir = Path(secrets_dir or Path.home() / ".config" / "local")
        self.assume_yes = assume_yes
        self.zap = zap

    def _run_required(self, command: Sequence[object], operation: str) -> CommandResult:
        return require_success(self.runner.run(command), operation)

    def dotfiles(self) -> None:
        self._run_required(["chezmoi", "update"], "Chezmoi update")

    def packages(self) -> None:
        merged_brewfile_contents(self.extras_dir, self.profile)
        dry_run = bool(getattr(self.runner, "dry_run", False))
        brewfile = (
            Path(f"<merged-{self.profile}.Brewfile>")
            if dry_run
            else build_merged_brewfile(self.extras_dir, self.profile)
        )
        try:
            self._run_required(["brew", "update"], "Homebrew metadata update")
            self._run_required(["brew", "bundle", "install", "--file", brewfile], "Homebrew bundle install")
            self._run_required(["brew", "bundle", "upgrade", "--file", brewfile], "Homebrew bundle upgrade")
        finally:
            if not dry_run:
                brewfile.unlink(missing_ok=True)

    def tools(self) -> None:
        config = self.extras_dir / f"mise.{self.profile}.toml"
        lock = self.extras_dir / f"mise.{self.profile}.lock"
        if not config.is_file():
            raise UpdateError(f"mise configuration is missing: {config.name}")
        if not lock.is_file():
            raise UpdateError(f"mise lock is missing: {lock.name}")
        environment = build_mise_environment(self.runner.env, config)
        require_success(
            self.runner.run(["mise", "--locked", "install"], env=environment),
            "mise tool installation",
        )
        require_success(self.runner.run(["mise", "doctor"], env=environment), "mise verification")

    def skills(self) -> None:
        manifest = self.extras_dir / "skills.common"
        if not manifest.is_file():
            raise UpdateError("pinned skill manifest is missing")
        environment = build_mise_environment(
            getattr(self.runner, "env", os.environ),
            self.extras_dir / f"mise.{self.profile}.toml",
        )
        dry_run = bool(getattr(self.runner, "dry_run", False))
        for raw_line in manifest.read_text(encoding="utf-8").splitlines():
            line = raw_line.strip()
            if not line or line.startswith("#"):
                continue
            fields = [field.strip() for field in line.split("|")]
            if len(fields) != 3 or not all(fields):
                raise UpdateError(f"invalid skill definition: {line}")
            source, agents, skill = fields
            temporary: Optional[tempfile.TemporaryDirectory[str]] = None
            if source.startswith("./"):
                install_source = str(self.source_dir / source[2:])
            elif source.startswith("https://"):
                repository, commit = parse_pinned_github_source(source)
                if dry_run:
                    checkout = Path(f"<pinned-{skill}-{commit[:12]}>")
                else:
                    temporary = tempfile.TemporaryDirectory(prefix=f"dotfiles-skill-{skill}-")
                    checkout = Path(temporary.name) / "source"
                try:
                    require_success(
                        self.runner.run(["git", "init", checkout], env=environment),
                        f"initialization of pinned {skill} source",
                    )
                    require_success(
                        self.runner.run(
                            ["git", "-C", checkout, "fetch", "--depth=1", repository, commit],
                            env=environment,
                        ),
                        f"fetch of pinned {skill} source",
                    )
                    require_success(
                        self.runner.run(
                            ["git", "-C", checkout, "checkout", "--detach", "FETCH_HEAD"],
                            env=environment,
                        ),
                        f"checkout of pinned {skill} source",
                    )
                    revision = require_success(
                        self.runner.run(["git", "-C", checkout, "rev-parse", "HEAD"], env=environment),
                        f"verification of pinned {skill} source",
                    )
                    if not dry_run and revision.stdout.strip() != commit:
                        raise UpdateError(
                            f"pinned {skill} source resolved to {revision.stdout.strip()}, expected {commit}"
                        )
                    install_source = str(checkout)
                    self._install_skill(install_source, agents, skill, environment)
                finally:
                    if temporary is not None:
                        temporary.cleanup()
                continue
            else:
                raise UpdateError(f"unsupported skill source: {source}")
            self._install_skill(install_source, agents, skill, environment)

    def _install_skill(
        self,
        source: str,
        agents: str,
        skill: str,
        environment: Mapping[str, str],
    ) -> None:
        command = [
            "mise",
            "exec",
            "--",
            "npx",
            "--yes",
            f"skills@{SKILLS_VERSION}",
            "add",
            source,
            "--global",
            "--copy",
            "--yes",
            "--skill",
            skill,
        ]
        for agent in (entry.strip() for entry in agents.split(",")):
            if agent:
                command.extend(("--agent", agent))
        require_success(
            self.runner.run(command, env=environment),
            f"skill installation from {source}",
        )

    def secrets(self) -> None:
        if self.runner.dry_run:
            self.runner.run(["bw", "sync"])
            self.runner.run(["bw", "get", "item", f"_chezmoi_{self.profile}"])
            return
        fetch_secrets(self.profile, self.runner, self.secrets_dir, self.runner.env)

    def atuin(self) -> None:
        if self.runner.dry_run:
            self.runner.run(["atuin", "login"])
            self.runner.run(["atuin", "sync"])
            return
        status = self.runner.run(["atuin", "status"])
        if status.returncode:
            self._run_required(["atuin", "login"], "Atuin login")
        self._run_required(["atuin", "sync"], "Atuin sync")

    def macos(self) -> None:
        self._run_required(["bash", self.extras_dir / "config-osx.sh"], "macOS defaults")

    def cleanup(self) -> None:
        merged_brewfile_contents(self.extras_dir, self.profile)
        dry_run = bool(getattr(self.runner, "dry_run", False))
        brewfile = (
            Path(f"<merged-{self.profile}.Brewfile>")
            if dry_run
            else build_merged_brewfile(self.extras_dir, self.profile)
        )
        try:
            analysis_command: list[object] = ["brew", "bundle", "cleanup", "--file", brewfile]
            if self.zap:
                analysis_command.append("--zap")
            analysis = self.runner.run(analysis_command)
            analysis_output = "\n".join(
                output for output in (analysis.stdout, analysis.stderr) if output
            )
            pending_changes = (
                analysis.returncode == 1
                and "Run `brew bundle cleanup --force` to make these changes."
                in analysis_output
            )
            if analysis.returncode and not pending_changes:
                require_success(analysis, "Homebrew cleanup analysis")
            if analysis.stdout:
                print(analysis.stdout, end="")
            if analysis.stderr:
                print(analysis.stderr, end="", file=sys.stderr)
            if dry_run:
                return
            if not self.assume_yes:
                answer = input("Remove undeclared Homebrew content? [y/N] ")
                if answer.strip().lower() not in ("y", "yes"):
                    print("Cleanup cancelled.")
                    return
            command = [*analysis_command, "--force"]
            self._run_required(command, "Homebrew cleanup")
        finally:
            if not dry_run:
                brewfile.unlink(missing_ok=True)

    def doctor(self) -> None:
        failures: list[str] = []
        brewfile = build_merged_brewfile(self.extras_dir, self.profile)
        mise_environment = build_mise_environment(
            self.runner.env,
            self.extras_dir / f"mise.{self.profile}.toml",
        )
        try:
            checks: Iterable[tuple[Sequence[object], str, Optional[Mapping[str, str]]]] = (
                (["chezmoi", "doctor"], "Chezmoi health", None),
                (["brew", "bundle", "check", "--file", brewfile], "Brewfile drift", None),
                (["mise", "doctor"], "mise health", mise_environment),
                (["mise", "current"], "mise versions", mise_environment),
            )
            for command, label, environment in checks:
                result = self.runner.run(command, env=environment)
                if result.returncode:
                    failures.append(label)

            status = self.runner.run(
                ["git", "-C", self.source_dir, "status", "--porcelain=v1"]
            )
            if status.returncode or status.stdout.strip():
                failures.append("clean Chezmoi source tree")

            desired_krew = set()
            for source in (
                self.extras_dir / "Brewfile.common",
                self.extras_dir / f"Brewfile.{self.profile}",
            ):
                for line in source.read_text(encoding="utf-8").splitlines():
                    match = re.match(r'^\s*krew\s+["\']([^"\']+)["\']', line)
                    if match:
                        desired_krew.add(match.group(1))
            installed_krew = self.runner.run(["kubectl", "krew", "list"])
            if installed_krew.returncode:
                failures.append("Krew drift check")
            else:
                installed = {
                    line.strip()
                    for line in installed_krew.stdout.splitlines()
                    if line.strip() and not line.lower().startswith("plugin")
                }
                if installed != desired_krew:
                    failures.append("Krew plugin drift")

            for secret in ALLOWED_ATTACHMENTS:
                path = self.secrets_dir / secret
                if not path.is_file() or (path.stat().st_mode & 0o777) != 0o600:
                    failures.append(f"secret file {secret} presence/mode")
            if (self.secrets_dir.exists() and (self.secrets_dir.stat().st_mode & 0o777) != 0o700):
                failures.append("secret directory mode")

            restic_config = Path("/Library/Application Support/restic-backup/repository.conf")
            if self.profile == "home":
                restic_failure, insecure_http, root_protected = inspect_restic_config(
                    restic_config
                )
                if restic_failure:
                    failures.append(restic_failure)
                if root_protected:
                    print(
                        "Warning: Restic repository configuration is root-protected; "
                        "run doctor as an administrator for a direct content check.",
                        file=sys.stderr,
                    )
                    try:
                        private_restic = (self.secrets_dir / "secrets.zsh").read_text(
                            encoding="utf-8"
                        )
                    except OSError:
                        private_restic = ""
                    insecure_http = bool(
                        re.search(r"^\s*export\s+RESTIC_REPOSITORY=.*http://", private_restic, re.MULTILINE)
                    )
                if insecure_http:
                    print("Warning: Restic uses unencrypted HTTP transport.", file=sys.stderr)

            manifest = (self.extras_dir / "skills.common").read_text(encoding="utf-8")
            external_sources = [
                line.split("|", 1)[0]
                for line in manifest.splitlines()
                if line.startswith("https://")
            ]
            if not external_sources or any(
                not re.search(r"/tree/[0-9a-f]{40}$", source) for source in external_sources
            ):
                failures.append("commit-pinned external skill definitions")

            executables = {
                "go": "go",
                "node": "node",
                "erlang": "erl",
                "elixir": "elixir",
                "opentofu": "tofu",
                "terraform": "terraform",
            }
            managed_tools = ["go", "node", "erlang", "elixir"]
            managed_tools.append("opentofu" if self.profile == "home" else "terraform")
            for tool in managed_tools:
                location = self.runner.run(
                    ["mise", "which", executables[tool]],
                    env=mise_environment,
                )
                if location.returncode:
                    failures.append(f"mise executable path for {tool}")
                    continue
                path = location.stdout.strip()
                if any(fragment in path for fragment in ("/opt/homebrew/Cellar/go/", "/opt/homebrew/Cellar/node/", "/opt/homebrew/Cellar/elixir/", "/.goenv/", "/.tfenv/")):
                    failures.append(f"removed manager still owns {tool}")
            if failures:
                raise AggregateUpdateError("doctor failures: " + ", ".join(failures))
        finally:
            brewfile.unlink(missing_ok=True)

    def bootstrap(self) -> None:
        self.packages()
        self.tools()
        self.skills()
        try:
            self.secrets()
        except OptionalStageError as error:
            print(f"Warning: {error}", file=sys.stderr)
        self.atuin()
        self.macos()

    def all(self) -> None:
        failures = []
        for name in ("dotfiles", "packages", "tools", "skills", "macos"):
            try:
                getattr(self, name)()
            except (UpdateError, FileNotFoundError, ValueError) as error:
                failures.append(f"{name}: {error}")
        if failures:
            raise AggregateUpdateError("; ".join(failures))


def _profile_from_chezmoi() -> str:
    config = Path.home() / ".config" / "chezmoi" / "chezmoi.toml"
    if not config.is_file():
        return "home"
    match = re.search(r'^\s*profile\s*=\s*["\'](home|work)["\']', config.read_text(encoding="utf-8"), re.MULTILINE)
    return match.group(1) if match else "home"


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Atomic dotfiles update manager")
    parser.add_argument("--profile", choices=VALID_PROFILES, default=_profile_from_chezmoi())
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--yes", action="store_true", help="confirm cleanup")
    subparsers = parser.add_subparsers(dest="command", required=True)
    for name in ("bootstrap", "all", "dotfiles", "packages", "tools", "skills", "secrets", "macos", "doctor"):
        subparsers.add_parser(name)
    cleanup = subparsers.add_parser("cleanup")
    cleanup.add_argument("--zap", action="store_true", help="also remove associated application data")
    return parser


def main(argv: Optional[Sequence[str]] = None) -> int:
    arguments = build_parser().parse_args(argv)
    runner = CommandRunner(dry_run=arguments.dry_run)
    manager = UpdateManager(
        arguments.profile,
        runner,
        assume_yes=arguments.yes,
        zap=getattr(arguments, "zap", False),
    )
    try:
        getattr(manager, arguments.command)()
    except (UpdateError, FileNotFoundError, ValueError) as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
