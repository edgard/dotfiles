import importlib.util
import json
import os
import stat
import tempfile
import unittest
from pathlib import Path
from unittest import mock


MODULE_PATH = Path(__file__).parents[1] / "extras" / "update_manager.py"
SPEC = importlib.util.spec_from_file_location("update_manager", MODULE_PATH)
update_manager = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(update_manager)


class FakeRunner:
    def __init__(self, responses=None):
        self.calls = []
        self.responses = list(responses or [])

    def run(self, command, **kwargs):
        command = [str(part) for part in command]
        self.calls.append((command, kwargs))
        if self.responses:
            response = self.responses.pop(0)
        else:
            response = update_manager.CommandResult(command, 0, "", "")
        output_index = command.index("--output") + 1 if "--output" in command else None
        if output_index is not None and response.returncode == 0:
            Path(command[output_index]).write_text("downloaded secret\n")
        return response


class BrewfileTests(unittest.TestCase):
    def test_rejects_unknown_profile(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            (base / "Brewfile.common").write_text('brew "jq"\n')
            with self.assertRaisesRegex(ValueError, "home or work"):
                update_manager.build_merged_brewfile(base, "personal")

    def test_requires_profile_brewfile(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            (base / "Brewfile.common").write_text('brew "jq"\n')
            with self.assertRaisesRegex(FileNotFoundError, "Brewfile.home"):
                update_manager.build_merged_brewfile(base, "home")

    def test_merges_exact_directives_without_corrupting_hashes_or_duplicates(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            (base / "Brewfile.common").write_text(
                'tap "example/tools", "https://example.test/tap#stable"\n'
                'brew "jq" # comment\n'
                'krew "neat"\n'
            )
            (base / "Brewfile.home").write_text(
                'brew "jq"\n'
                'cask "ghostty"\n'
            )
            merged = update_manager.build_merged_brewfile(base, "home")
            self.addCleanup(merged.unlink)
            contents = merged.read_text()
            self.assertIn('https://example.test/tap#stable', contents)
            self.assertEqual(contents.count('brew "jq"'), 1)
            self.assertLess(contents.index('brew "jq"'), contents.index('cask "ghostty"'))
            self.assertLess(contents.index('cask "ghostty"'), contents.index('krew "neat"'))


class RunnerTests(unittest.TestCase):
    def test_dry_run_does_not_spawn(self):
        runner = update_manager.CommandRunner(dry_run=True)
        result = runner.run(["false"])
        self.assertEqual(result.returncode, 0)
        self.assertEqual(runner.commands, [["false"]])
        self.assertEqual(runner.results, [result])


class SkillTests(unittest.TestCase):
    def test_pinned_source_is_verified_locally_before_skills_cli(self):
        source = (
            "https://github.com/example/skills/tree/"
            "0123456789abcdef0123456789abcdef01234567"
        )
        repository, commit = update_manager.parse_pinned_github_source(source)
        self.assertEqual(repository, "https://github.com/example/skills.git")
        self.assertEqual(commit, "0123456789abcdef0123456789abcdef01234567")

    def test_dry_run_records_pinned_checkout_without_creating_it(self):
        source = (
            "https://github.com/example/skills/tree/"
            "0123456789abcdef0123456789abcdef01234567"
        )
        with tempfile.TemporaryDirectory() as directory:
            extras = Path(directory)
            (extras / "skills.common").write_text(f"{source}|codex|example\n")
            (extras / "mise.home.toml").write_text('[tools]\nnode = "26"\n')
            (extras / "mise.home.lock").write_text("lockfile_version = 1\n")
            before = sorted(extras.iterdir())
            runner = update_manager.CommandRunner(dry_run=True)
            update_manager.UpdateManager("home", runner, extras_dir=extras).skills()
            self.assertEqual(before, sorted(extras.iterdir()))
            flattened = [part for command in runner.commands for part in command]
            self.assertIn("https://github.com/example/skills.git", flattened)
            self.assertIn("0123456789abcdef0123456789abcdef01234567", flattened)
            self.assertNotIn(source, flattened)


class OrchestrationTests(unittest.TestCase):
    def make_manager(self):
        manager = update_manager.UpdateManager("home", FakeRunner())
        calls = []
        for name in ("dotfiles", "packages", "tools", "skills", "secrets", "atuin", "macos"):
            setattr(manager, name, lambda stage=name: calls.append(stage))
        return manager, calls

    def test_bootstrap_order(self):
        manager, calls = self.make_manager()
        manager.bootstrap()
        self.assertEqual(calls, ["packages", "tools", "skills", "secrets", "atuin", "macos"])

    def test_bootstrap_treats_secret_failure_as_optional(self):
        manager, calls = self.make_manager()

        def fail_secrets():
            calls.append("secrets")
            raise update_manager.OptionalStageError("vault locked")

        manager.secrets = fail_secrets
        manager.bootstrap()
        self.assertEqual(calls[-2:], ["atuin", "macos"])

    def test_bootstrap_stops_after_required_failure(self):
        manager, calls = self.make_manager()

        def fail_tools():
            calls.append("tools")
            raise update_manager.UpdateError("mise failed")

        manager.tools = fail_tools
        with self.assertRaises(update_manager.UpdateError):
            manager.bootstrap()
        self.assertEqual(calls, ["packages", "tools"])

    def test_all_runs_independent_stages_and_aggregates_failures(self):
        manager, calls = self.make_manager()

        def fail_packages():
            calls.append("packages")
            raise update_manager.UpdateError("brew failed")

        manager.packages = fail_packages
        with self.assertRaisesRegex(update_manager.AggregateUpdateError, "packages"):
            manager.all()
        self.assertEqual(calls, ["dotfiles", "packages", "tools", "skills", "macos"])


class PackageTests(unittest.TestCase):
    def make_extras(self, directory):
        extras = Path(directory)
        (extras / "Brewfile.common").write_text('brew "jq"\n')
        (extras / "Brewfile.home").write_text('cask "ghostty"\n')
        return extras

    def test_packages_runs_only_update_install_and_upgrade_against_one_file(self):
        with tempfile.TemporaryDirectory() as directory:
            runner = FakeRunner()
            manager = update_manager.UpdateManager(
                "home", runner, extras_dir=self.make_extras(directory)
            )
            manager.packages()
            commands = [call[0] for call in runner.calls]
            self.assertEqual(commands[0], ["brew", "update"])
            self.assertEqual(commands[1][:3], ["brew", "bundle", "install"])
            self.assertEqual(commands[2][:3], ["brew", "bundle", "upgrade"])
            self.assertEqual(commands[1][-1], commands[2][-1])
            self.assertFalse(Path(commands[1][-1]).exists())

    def test_dry_run_does_not_create_a_merged_file(self):
        with tempfile.TemporaryDirectory() as directory:
            extras = self.make_extras(directory)
            before = sorted(path.name for path in extras.iterdir())
            runner = update_manager.CommandRunner(dry_run=True)
            update_manager.UpdateManager("home", runner, extras_dir=extras).packages()
            self.assertEqual(before, sorted(path.name for path in extras.iterdir()))
            self.assertEqual(len(runner.commands), 3)

    def test_cleanup_analysis_failure_is_an_error(self):
        with tempfile.TemporaryDirectory() as directory:
            runner = FakeRunner([
                update_manager.CommandResult(["brew"], 1, "", "analysis failed")
            ])
            manager = update_manager.UpdateManager(
                "home", runner, extras_dir=self.make_extras(directory), assume_yes=True
            )
            with self.assertRaisesRegex(update_manager.UpdateError, "analysis failed"):
                manager.cleanup()


class SecretTests(unittest.TestCase):
    def result(self, command, returncode=0, stdout="", stderr=""):
        return update_manager.CommandResult(command, returncode, stdout, stderr)

    def test_rejects_unsafe_attachment_names(self):
        for name in ("../secrets.zsh", "/tmp/secrets.zsh", ".", "unknown"):
            with self.subTest(name=name):
                self.assertFalse(update_manager.is_allowed_attachment(name))
        self.assertTrue(update_manager.is_allowed_attachment("gitconfig"))
        self.assertTrue(update_manager.is_allowed_attachment("secrets.zsh"))

    def test_downloads_allowed_attachment_atomically_with_private_modes(self):
        item = {
            "id": "item-id",
            "attachments": [
                {"id": "good", "fileName": "secrets.zsh"},
            ],
        }
        runner = FakeRunner([
            self.result(["bw", "sync"]),
            self.result(["bw", "get"], stdout=json.dumps(item)),
            self.result(["bw", "attachment"]),
        ])
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "local"
            update_manager.fetch_secrets("home", runner, target, {"BW_SESSION": "existing"})
            secret = target / "secrets.zsh"
            self.assertEqual(secret.read_text(), "downloaded secret\n")
            self.assertEqual(stat.S_IMODE(target.stat().st_mode), 0o700)
            self.assertEqual(stat.S_IMODE(secret.stat().st_mode), 0o600)

    def test_unknown_attachment_rejects_item_before_any_download(self):
        item = {
            "id": "item-id",
            "attachments": [
                {"id": "good", "fileName": "secrets.zsh"},
                {"id": "bad", "fileName": "../escape"},
            ],
        }
        runner = FakeRunner([
            self.result(["bw", "sync"]),
            self.result(["bw", "get"], stdout=json.dumps(item)),
        ])
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "local"
            with self.assertRaisesRegex(update_manager.OptionalStageError, "unsafe"):
                update_manager.fetch_secrets(
                    "home", runner, target, {"BW_SESSION": "existing"}
                )
            self.assertFalse(target.exists())
            self.assertEqual(len(runner.calls), 2)

    def test_failed_download_preserves_existing_file_and_locks_managed_session(self):
        item = {"id": "item-id", "attachments": [{"id": "good", "fileName": "gitconfig"}]}
        runner = FakeRunner([
            self.result(["bw", "login", "--check"], returncode=1),
            self.result(["bw", "login", "--raw"], stdout="session-token\n"),
            self.result(["bw", "sync"]),
            self.result(["bw", "get"], stdout=json.dumps(item)),
            self.result(["bw", "attachment"], returncode=1, stderr="download failed"),
            self.result(["bw", "lock"]),
        ])
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "local"
            target.mkdir()
            existing = target / "gitconfig"
            existing.write_text("keep me\n")
            with self.assertRaises(update_manager.OptionalStageError):
                update_manager.fetch_secrets("home", runner, target, {}, tty_available=True)
            self.assertEqual(existing.read_text(), "keep me\n")
            self.assertEqual(runner.calls[-1][0], ["bw", "lock"])

    def test_later_download_failure_preserves_all_existing_files(self):
        item = {
            "id": "item-id",
            "attachments": [
                {"id": "first", "fileName": "gitconfig"},
                {"id": "second", "fileName": "secrets.zsh"},
            ],
        }
        runner = FakeRunner([
            self.result(["bw", "sync"]),
            self.result(["bw", "get"], stdout=json.dumps(item)),
            self.result(["bw", "attachment"]),
            self.result(["bw", "attachment"], returncode=1),
        ])
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "local"
            target.mkdir()
            gitconfig = target / "gitconfig"
            secrets = target / "secrets.zsh"
            gitconfig.write_text("old git\n")
            secrets.write_text("old secrets\n")
            with self.assertRaises(update_manager.OptionalStageError):
                update_manager.fetch_secrets(
                    "home", runner, target, {"BW_SESSION": "existing"}
                )
            self.assertEqual(gitconfig.read_text(), "old git\n")
            self.assertEqual(secrets.read_text(), "old secrets\n")

    def test_sync_failure_locks_session_opened_by_updater(self):
        runner = FakeRunner([
            self.result(["bw", "login", "--check"], returncode=1),
            self.result(["bw", "login", "--raw"], stdout="session-token\n"),
            self.result(["bw", "sync"], returncode=1),
            self.result(["bw", "lock"]),
        ])
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaises(update_manager.OptionalStageError):
                update_manager.fetch_secrets(
                    "home", runner, Path(directory), {}, tty_available=True
                )
        self.assertEqual(runner.calls[-1][0], ["bw", "lock"])

    def test_real_runner_skips_when_bitwarden_is_unavailable(self):
        with tempfile.TemporaryDirectory() as directory:
            with mock.patch.object(update_manager.shutil, "which", return_value=None):
                with self.assertRaisesRegex(update_manager.OptionalStageError, "unavailable"):
                    update_manager.fetch_secrets(
                        "home",
                        update_manager.CommandRunner(),
                        Path(directory),
                        {},
                        tty_available=False,
                    )


if __name__ == "__main__":
    unittest.main()
