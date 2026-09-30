"""Exercise global integration with disposable homes and real terminal consent."""
import os
from pathlib import Path
import pty
import select
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]


class GlobalIntegration(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="sia-global-")
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.repo = self.base / "repo"
        self.repo.mkdir()
        subprocess.run(["git", "init", "-q", str(self.repo)], check=True)
        self.home = self.base / "home"
        self.home.mkdir()
        self.env = dict(os.environ, HOME=str(self.home), SIA_INTEGRATION="global", SIA_CONSENT="no")
        self.hosts = [self.home / ".codex/AGENTS.md", self.home / ".claude/CLAUDE.md",
                      self.home / ".copilot/copilot-instructions.md"]

    def install(self, **env):
        return subprocess.run(["sh", str(ROOT / "install.sh")], cwd=self.repo,
                              env=dict(self.env, **env), stdin=subprocess.DEVNULL,
                              capture_output=True, text=True)

    def assert_clean_repo(self):
        self.assertFalse((self.repo / "AGENTS.md").exists())
        self.assertFalse((self.repo / ".claude").exists())
        self.assertTrue((self.repo / ".ai/sia.md").is_file())
        self.assertFalse((self.repo / ".ai/SIA.md").exists())

    def test_decline_and_manual(self):
        result = self.install()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assert_clean_repo()
        self.assertIn("load .ai/sia.md", result.stdout)
        self.assertTrue((self.home / ".config/sia/AGENTS.md").is_file())
        self.assertTrue(all(not p.exists() for p in self.hosts))
        other = self.base / "manual-home"
        result = self.install(HOME=str(other), SIA_INTEGRATION="manual")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(other.exists())

    def test_accept_preserve_and_update(self):
        for path in self.hosts:
            path.parent.mkdir(parents=True)
            path.write_text("Keep my instructions.\n")
            path.chmod(0o640)
        result = self.install(SIA_CONSENT="yes")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assert_clean_repo()
        for path in self.hosts:
            self.assertIn("Keep my instructions.", path.read_text())
            self.assertEqual(path.stat().st_mode & 0o777, 0o640)
            self.assertEqual(path.read_text().count("<!-- sia:global:start -->"), 1)
        shared = self.home / ".config/sia/AGENTS.md"
        shared.write_text(shared.read_text().replace("strictly opt-in", "OLD SENTINEL"))
        result = self.install()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("OLD SENTINEL", shared.read_text())
        for path in self.hosts:
            self.assertEqual(path.read_text().count("<!-- sia:global:start -->"), 1)

    def test_no_terminal_skips_injection(self):
        env = dict(self.env, SIA_CONSENT="ask")
        env.pop("SIA_INTEGRATION")
        result = subprocess.run(["sh", str(ROOT / "install.sh")], cwd=self.repo,
                                env=env, start_new_session=True,
                                stdin=subprocess.DEVNULL, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("No interactive terminal", result.stderr)
        self.assertTrue(all(not p.exists() for p in self.hosts))

    def test_global_directory_layout_fails_before_writes(self):
        (self.home / ".config").write_text("Keep me")
        result = self.install()
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse((self.repo / ".ai").exists())
        self.assertEqual((self.home / ".config").read_text(), "Keep me")

    def test_existing_repository_files_ignored(self):
        (self.repo / "AGENTS.md").write_text("<!-- sia:entrypoint:start -->\n")
        (self.repo / ".claude").write_text("Project file\n")
        result = self.install()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.repo / "AGENTS.md").read_text(), "<!-- sia:entrypoint:start -->\n")
        self.assertEqual((self.repo / ".claude").read_text(), "Project file\n")

    def test_user_owned_reference_untouched(self):
        path = self.hosts[0]
        path.parent.mkdir()
        content = "Read ~/.config/sia/AGENTS.md\nKeep this exact text."
        path.write_text(content)
        result = self.install(SIA_CONSENT="yes")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(path.read_text(), content)

    def test_malformed_and_symlink_targets_fail_before_writes(self):
        path = self.hosts[0]
        path.parent.mkdir()
        for shape in ["malformed", "symlink", "directory"]:
            if shape == "malformed":
                path.write_text("<!-- sia:global:start -->\n")
            elif shape == "symlink":
                path.symlink_to(self.base / "missing")
            else:
                path.mkdir()
            result = self.install(SIA_CONSENT="yes")
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse((self.repo / ".ai").exists())
            self.assertFalse((self.home / ".config").exists())
            if path.is_dir():
                path.rmdir()
            else:
                path.unlink()

    def test_invalid_settings_fail_before_writes(self):
        for setting in [{"SIA_INTEGRATION": "bad"}, {"SIA_INTEGRATION": "repository"}, {"SIA_CONSENT": "bad"}]:
            self.assertNotEqual(self.install(**setting).returncode, 0)
            self.assertFalse((self.repo / ".ai").exists())

    def test_terminal_consent_with_stdin_bootstrap(self):
        # The bootstrap script occupies stdin; prompts must use the controlling terminal.
        source = self.base / "source"
        subprocess.run(["git", "clone", "-q", "--no-hardlinks", str(ROOT), str(source)], check=True)
        # Include working changes in the remote fixture.
        import shutil
        shutil.copyfile(ROOT / "install.sh", source / "install.sh")
        shutil.copytree(ROOT / "src", source / "src", dirs_exist_ok=True)
        subprocess.run(["git", "add", "."], cwd=source, check=True)
        subprocess.run(["git", "-c", "user.name=Test", "-c", "user.email=test@example.invalid",
                        "commit", "-qm", "fixture"], cwd=source, check=True)
        pid, terminal = pty.fork()
        if pid == 0:
            os.chdir(self.repo)
            os.environ.update(self.env, SIA_CONSENT="ask", GITHUB_URL=f"file://{source}")
            script = os.open(ROOT / "install.sh", os.O_RDONLY)
            os.dup2(script, 0)
            os.execvp("sh", ["sh", "-s"])
        output = b""
        answered = 0
        try:
            while True:
                ready, _, _ = select.select([terminal], [], [], 15)
                self.assertTrue(ready, "installer stalled waiting for consent")
                try:
                    chunk = os.read(terminal, 4096)
                except OSError:
                    break
                if not chunk:
                    break
                output += chunk
                count = output.count(b"[y/N]")
                while answered < count:
                    os.write(terminal, [b"y\n", b"n\n", b"y\n"][answered])
                    answered += 1
        finally:
            os.close(terminal)
            _, status = os.waitpid(pid, 0)
        self.assertEqual(os.waitstatus_to_exitcode(status), 0, output.decode())
        self.assertEqual(answered, 3, output.decode())
        self.assertTrue(self.hosts[0].exists())
        self.assertFalse(self.hosts[1].exists())
        self.assertTrue(self.hosts[2].exists())
        self.assert_clean_repo()


if __name__ == "__main__":
    unittest.main()
