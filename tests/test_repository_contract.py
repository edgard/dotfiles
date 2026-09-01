import subprocess
import unittest
from pathlib import Path


ROOT = Path(__file__).parents[1]


class RepositoryContractTests(unittest.TestCase):
    def test_only_prerequisite_chezmoi_lifecycle_script_remains(self):
        scripts = sorted(path.name for path in (ROOT / ".chezmoiscripts").iterdir())
        self.assertEqual(scripts, ["run_once_before_01-install-deps.sh.tmpl"])

    def test_security_defaults_and_compatibility_floor(self):
        atuin = (ROOT / "dot_config" / "atuin" / "config.toml").read_text()
        self.assertIn("secrets_filter = true", atuin)
        macos = (ROOT / "extras" / "config-osx.sh").read_text()
        self.assertNotIn("skip-verify", macos)
        self.assertEqual((ROOT / ".chezmoiversion").read_text().strip(), "2.50.0")

    def test_update_cli_has_only_final_commands(self):
        result = subprocess.run(
            ["python3", str(ROOT / "dot_local" / "bin" / "executable_update"), "--help"],
            capture_output=True,
            text=True,
            env={"CHEZMOI_SOURCE_DIR": str(ROOT)},
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        for command in (
            "bootstrap",
            "all",
            "dotfiles",
            "packages",
            "tools",
            "skills",
            "secrets",
            "macos",
            "cleanup",
            "doctor",
        ):
            self.assertIn(command, result.stdout)
        self.assertNotIn("install alias", result.stdout)

    def test_external_skills_and_installer_are_fully_pinned(self):
        manifest = (ROOT / "extras" / "skills.common").read_text()
        self.assertIn("f23267105ad1f4ccd94af45d382584ad45b586f7", manifest)
        self.assertIn("882ef55e377dbf9a4dbe496bb41ac6ccd0e555cf", manifest)
        updater = (ROOT / "extras" / "update_manager.py").read_text()
        self.assertIn('SKILLS_VERSION = "1.5.23"', updater)
        self.assertNotIn("skills@latest", updater)

    def test_quality_gate_is_single_aggregate_and_checkout_is_sha_pinned(self):
        workflow = (ROOT / ".github" / "workflows" / "quality-gate.yml").read_text()
        self.assertIn("name: Quality Gate", workflow)
        self.assertIn(
            "actions/checkout@d23441a48e516b6c34aea4fa41551a30e30af803",
            workflow,
        )
        self.assertIn("contents: read", workflow)
        self.assertLess(workflow.index("brew update"), workflow.index("brew install"))


if __name__ == "__main__":
    unittest.main()
