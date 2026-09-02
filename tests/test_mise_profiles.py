import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).parents[1]


class MiseProfileTests(unittest.TestCase):
    def test_common_runtime_versions_are_declared(self):
        config = (ROOT / "dot_config" / "mise" / "config.toml.tmpl").read_text()
        for declaration in (
            'go = "prefix:1.27"',
            'node = "prefix:26"',
            'erlang = "prefix:29"',
            'elixir = "prefix:1.20"',
        ):
            self.assertIn(declaration, config)
        self.assertIn('min_version = "2026.9.0"', config)

    def test_profile_specific_iac_tools_and_locks_exist(self):
        config = (ROOT / "dot_config" / "mise" / "config.toml.tmpl").read_text()
        self.assertIn('opentofu = "prefix:1.12"', config)
        self.assertIn('terraform = "prefix:1.16"', config)
        self.assertTrue((ROOT / "extras" / "mise.home.lock").is_file())
        self.assertTrue((ROOT / "extras" / "mise.work.lock").is_file())

    def test_locks_resolve_expected_versions_and_profile_iac(self):
        home = (ROOT / "extras" / "mise.home.lock").read_text()
        work = (ROOT / "extras" / "mise.work.lock").read_text()
        for lock in (home, work):
            for version in ("1.27.0", "26.8.1", "29.0.5", "1.20.4-otp-29"):
                self.assertIn(f'version = "{version}"', lock)
        self.assertIn('[[tools.opentofu]]', home)
        self.assertNotIn('[[tools.terraform]]', home)
        self.assertIn('[[tools.terraform]]', work)
        self.assertNotIn('[[tools.opentofu]]', work)

    def test_node_cli_tools_are_owned_by_mise_not_homebrew(self):
        brewfile = (ROOT / "extras" / "Brewfile.common").read_text()
        self.assertNotIn('brew "bitwarden-cli"', brewfile)
        self.assertNotIn('brew "prettier"', brewfile)
        for profile in ("home", "work"):
            config = (ROOT / "extras" / f"mise.{profile}.toml").read_text()
            lock = (ROOT / "extras" / f"mise.{profile}.lock").read_text()
            self.assertIn('bitwarden = "prefix:2026.8"', config)
            self.assertIn('prettier = "prefix:3.9"', config)
            self.assertIn('[[tools.bitwarden]]', lock)
            self.assertIn('[[tools.prettier]]', lock)

    def test_project_local_version_files_are_enabled_for_managed_tools(self):
        for profile in ("home", "work"):
            config = (ROOT / "extras" / f"mise.{profile}.toml").read_text()
            self.assertIn("idiomatic_version_file_enable_tools", config)
            for tool in ("go", "node", "erlang", "elixir"):
                self.assertIn(f'"{tool}"', config)

    @unittest.skipUnless(shutil.which("mise"), "mise is required for override validation")
    def test_project_local_idiomatic_file_overrides_global_node_version(self):
        with tempfile.TemporaryDirectory() as directory:
            (Path(directory) / ".node-version").write_text("26.8.0\n")
            environment = dict(os.environ)
            environment["MISE_GLOBAL_CONFIG_FILE"] = str(
                ROOT / "extras" / "mise.home.toml"
            )
            result = subprocess.run(
                ["mise", "-C", directory, "current", "node"],
                capture_output=True,
                text=True,
                env=environment,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(result.stdout.strip(), "26.8.0")

    def test_shell_activation_precedes_starship_and_removed_managers_are_absent(self):
        shell = (ROOT / "dot_zsh" / "02-env.zsh").read_text()
        self.assertLess(shell.index("mise activate zsh"), shell.index("starship init zsh"))
        brewfiles = "\n".join(
            (ROOT / "extras" / name).read_text()
            for name in ("Brewfile.common", "Brewfile.home", "Brewfile.work")
        )
        for directive in (
            'brew "go"',
            'brew "node"',
            'brew "elixir"',
            'brew "opentofu"',
            'brew "goenv"',
            'brew "tfenv"',
        ):
            self.assertNotIn(directive, brewfiles)
        self.assertIn('brew "mise"', brewfiles)

    @unittest.skipUnless(shutil.which("mise"), "mise is required for path validation")
    def test_installed_home_tools_resolve_outside_removed_manager_paths(self):
        environment = dict(os.environ)
        environment["MISE_GLOBAL_CONFIG_FILE"] = str(
            ROOT / "extras" / "mise.home.toml"
        )
        paths = []
        for tool in ("go", "node", "erl", "elixir", "tofu", "bw", "prettier"):
            result = subprocess.run(
                ["mise", "which", tool],
                capture_output=True,
                text=True,
                env=environment,
            )
            if result.returncode:
                self.skipTest("locked home tools are not installed on this validation host")
            paths.append(result.stdout.strip())
        for path in paths:
            self.assertIn("/.local/share/mise/installs/", path)
            for removed in ("/opt/homebrew/Cellar/", "/.goenv/", "/.tfenv/"):
                self.assertNotIn(removed, path)


if __name__ == "__main__":
    unittest.main()
