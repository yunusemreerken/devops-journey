
---

## 🧰 git-hatirla

> Never forget to commit again. Lives in your macOS menu bar, watches your repos, and uses Claude AI to write your commit messages.

### Features
- ✅ Monitors multiple Git repositories at once
- 🤖 Auto-generates commit messages using Claude AI (conventional commits format)
- 🔔 Scheduled daily reminders at a time you choose — set right from the menu bar
- 🚀 One-click commit + push

### Requirements
- macOS
- [xbar](https://xbarapp.com)
- `bash`, `git`, `curl`, `python3` (all pre-installed on macOS)
- [Anthropic API key](https://console.anthropic.com)

### Installation

**1. Install xbar**
```bash
brew install --cask xbar
```

**2. Copy the plugin**
```bash
cp git-hatirla/git-hatirla.1h.sh ~/Library/Application\ Support/xbar/plugins/
chmod +x ~/Library/Application\ Support/xbar/plugins/git-hatirla.1h.sh
```

**3. Configure the script**
```bash
open -a TextEdit ~/Library/Application\ Support/xbar/plugins/git-hatirla.1h.sh
```

Edit these lines:
```bash
WATCH_DIRS=(
  "/Users/yourname/Projects/my-repo"
  "/Users/yourname/Projects/repo-two"

)

ANTHROPIC_API_KEY="sk-ant-..."
```
## Tech

- `bash` — core scripting
- `xbar` — menu bar rendering
- `launchd` — scheduled notifications
- `Anthropic Claude API` — commit message generation
- `osascript` — macOS native notifications
- `gh` (GitHub CLI) — new repo creation & push



**4. Refresh xbar**

Click the xbar icon in your menu bar → Refresh All

### Usage

| Menu Item | Action |
|-----------|--------|
| `⚡ git` | Pending changes detected |
| `✅ git` | Everything is clean |
| `🤖 AI ile Commit At` | Stage all → AI generates message → commit |
| `🚀 Commit + Push` | Same as above + push to origin |
| `🔔 Hatırlatma Saati` | Pick a daily reminder time (09:00–22:00) |

---