import os
import shutil
import subprocess
import unittest
from pathlib import Path


ROOT = Path(__file__).parents[1]
INSTALLER = ROOT / "extras" / "setup-restic.ps1"
POWERSHELL = os.environ.get("POWERSHELL_EXE") or shutil.which("pwsh")


@unittest.skipUnless(POWERSHELL, "PowerShell is required")
class WindowsResticInstallerTests(unittest.TestCase):
    def run_installer(self, *arguments):
        return subprocess.run(
            [POWERSHELL, "-NoProfile", "-NonInteractive", "-File", str(INSTALLER), *arguments],
            capture_output=True,
            text=True,
        )

    def combined_output(self, result):
        return result.stdout + result.stderr

    def test_install_requires_repository_before_privilege_or_scheduler_checks(self):
        result = self.run_installer("install")
        self.assertNotEqual(result.returncode, 0)
        output = self.combined_output(result)
        self.assertIn("-Repository", output)
        self.assertNotIn("Administrator", output)
        self.assertNotIn("ScheduledTask", output)

    def test_http_repository_warns_before_environment_checks(self):
        result = self.run_installer(
            "install", "-Repository", "rest:http://restic.example:8000/"
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("unencrypted HTTP", self.combined_output(result))

    def test_https_and_custom_username_pass_argument_validation(self):
        result = self.run_installer(
            "install",
            "-Repository",
            "rest:https://restic.example/",
            "-RestUsername",
            "backup-user",
        )
        self.assertNotEqual(result.returncode, 0)
        output = self.combined_output(result)
        self.assertNotIn("unencrypted HTTP", output)
        self.assertNotIn("requires -Repository", output)
        self.assertNotIn("RestUsername must not be empty", output)


if __name__ == "__main__":
    unittest.main()
