import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).parents[1] / "dot_local" / "bin" / "executable_github-standardize-repo"


class GitHubStandardizeTests(unittest.TestCase):
    def test_dry_run_describes_least_privilege_defaults(self):
        result = subprocess.run(
            ["bash", str(SCRIPT), "edgard/example", "--dry-run", "--with-ci=Quality Gate"],
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        output = result.stdout
        self.assertIn("default_workflow_permissions: read", output)
        self.assertIn("can_approve_pull_request_reviews: false", output)
        self.assertIn("SHA pinning: required", output)
        self.assertIn("Dependabot security updates: enabled", output)
        self.assertIn("Default Branch Protection", output)
        self.assertNotIn("default_branch: master", output)

    def test_fake_gh_receives_exact_least_privilege_and_idempotent_payloads(self):
        fake_gh = '''#!/usr/bin/env python3
import json
import os
import sys
from pathlib import Path

arguments = sys.argv[1:]
endpoint = arguments[1]
method = arguments[arguments.index("--method") + 1] if "--method" in arguments else "GET"
payload = json.load(sys.stdin) if "--input" in arguments else None
with Path(os.environ["GH_CALL_LOG"]).open("a") as stream:
    stream.write(json.dumps({"endpoint": endpoint, "method": method, "payload": payload}) + "\\n")
if method == "GET" and endpoint.endswith("/rulesets"):
    print(json.dumps([
        {"id": 42, "name": "Default Branch Protection"},
        {"id": 7, "name": "Master Protection"},
    ]))
elif method == "GET":
    print(json.dumps({"default_branch": "trunk"}))
'''
        with tempfile.TemporaryDirectory() as directory:
            temporary = Path(directory)
            executable = temporary / "gh"
            executable.write_text(fake_gh)
            executable.chmod(0o755)
            log = temporary / "calls.jsonl"
            environment = dict(os.environ)
            environment["PATH"] = f"{temporary}:{environment['PATH']}"
            environment["GH_CALL_LOG"] = str(log)
            result = subprocess.run(
                [
                    "bash",
                    str(SCRIPT),
                    "edgard/example",
                    "--with-ci=Quality Gate",
                ],
                capture_output=True,
                text=True,
                env=environment,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            calls = [json.loads(line) for line in log.read_text().splitlines()]

        payloads = {
            (call["method"], call["endpoint"]): call["payload"]
            for call in calls
            if call["payload"] is not None
        }
        workflow = payloads[("PUT", "repos/edgard/example/actions/permissions/workflow")]
        self.assertEqual(
            workflow,
            {
                "default_workflow_permissions": "read",
                "can_approve_pull_request_reviews": False,
            },
        )
        actions = payloads[("PUT", "repos/edgard/example/actions/permissions")]
        self.assertEqual(
            actions,
            {"enabled": True, "allowed_actions": "selected", "sha_pinning_required": True},
        )
        selected = payloads[
            ("PUT", "repos/edgard/example/actions/permissions/selected-actions")
        ]
        self.assertEqual(
            selected,
            {"github_owned_allowed": True, "verified_allowed": True, "patterns_allowed": []},
        )
        self.assertEqual(
            payloads[("PATCH", "repos/edgard/example/code-scanning/default-setup")],
            {"state": "configured"},
        )
        repository_updates = [
            call["payload"]
            for call in calls
            if call["method"] == "PATCH" and call["endpoint"] == "repos/edgard/example"
        ]
        self.assertTrue(all("default_branch" not in payload for payload in repository_updates))
        ruleset = payloads[("PUT", "repos/edgard/example/rulesets/42")]
        self.assertEqual(ruleset["name"], "Default Branch Protection")
        self.assertEqual(ruleset["bypass_actors"][0]["bypass_mode"], "pull_request")
        pull_request = next(rule for rule in ruleset["rules"] if rule["type"] == "pull_request")
        self.assertEqual(pull_request["parameters"]["required_approving_review_count"], 0)
        self.assertTrue(pull_request["parameters"]["required_review_thread_resolution"])
        status = next(rule for rule in ruleset["rules"] if rule["type"] == "required_status_checks")
        self.assertEqual(status["parameters"]["required_status_checks"], [{"context": "Quality Gate"}])
        self.assertFalse(any(call["method"] == "POST" and call["endpoint"].endswith("/rulesets") for call in calls))
        self.assertTrue(
            any(
                call["method"] == "DELETE"
                and call["endpoint"] == "repos/edgard/example/rulesets/7"
                for call in calls
            )
        )


if __name__ == "__main__":
    unittest.main()
