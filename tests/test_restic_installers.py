import os
import subprocess
import unittest
from pathlib import Path


ROOT = Path(__file__).parents[1]
MACOS_INSTALLER = ROOT / "extras" / "setup-restic.sh"


class ResticInstallerTests(unittest.TestCase):
    def run_installer(self, *arguments):
        return subprocess.run(
            ["bash", str(MACOS_INSTALLER), *arguments],
            capture_output=True,
            text=True,
        )

    def test_install_requires_repository_before_root_check(self):
        if os.name == "nt":
            self.skipTest("macOS installer execution is covered on macOS")
        result = self.run_installer("install")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("--repository", result.stderr)
        self.assertNotIn("run as root", result.stdout + result.stderr)

    def test_http_repository_warns_before_root_check(self):
        if os.name == "nt":
            self.skipTest("macOS installer execution is covered on macOS")
        result = self.run_installer(
            "install", "--repository", "rest:http://restic.example:8000/"
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("unencrypted HTTP", result.stderr)

    def test_https_and_custom_username_are_accepted_before_root_check(self):
        if os.name == "nt":
            self.skipTest("macOS installer execution is covered on macOS")
        result = self.run_installer(
            "install",
            "--repository",
            "rest:https://restic.example/",
            "--username",
            "backup-user",
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn("unencrypted HTTP", result.stderr)
        self.assertNotIn("--username", result.stderr)
        self.assertIn("run as root", result.stderr)

    def test_templates_do_not_contain_repository_password_or_fixed_endpoint(self):
        templates = list((ROOT / "extras" / "restic").rglob("*.tmpl"))
        self.assertGreaterEqual(len(templates), 3)
        for template in templates:
            contents = template.read_text()
            self.assertNotIn("restic.edgard.org", contents)
            self.assertNotIn("RESTIC_REST_PASSWORD=", contents)

    def test_reinstall_replaces_schedulers_idempotently(self):
        macos = MACOS_INSTALLER.read_text()
        windows = (ROOT / "extras" / "setup-restic.ps1").read_text()
        self.assertLess(
            macos.index("launchctl bootout system/com.restic.backup"),
            macos.index('launchctl bootstrap system "$PLIST_FILE"'),
        )
        self.assertLess(
            windows.index("Unregister-ScheduledTask -TaskName $TaskName"),
            windows.index("Register-ScheduledTask -TaskName $TaskName"),
        )

    def test_runtime_templates_never_log_password_values(self):
        for template in (ROOT / "extras" / "restic").rglob("*.tmpl"):
            contents = template.read_text()
            for line in contents.splitlines():
                if "password" in line.lower():
                    self.assertNotIn("log", line.lower())


if __name__ == "__main__":
    unittest.main()
