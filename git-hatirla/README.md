# 🔔 git-hatirla

> AI-powered Git commit reminder for your macOS menu bar.

Watches your local Git repositories, reminds you when there are uncommitted changes, and uses Claude AI to write your commit messages automatically.

## How it works

1. Lives in your macOS menu bar via [xbar](https://xbarapp.com)
2. Scans your configured repos every hour
3. Shows `⚡ git` when there are pending changes, `✅ git` when everything is clean
4. Click to see details — then commit and push without opening a terminal
5. Set a daily reminder time directly from the menu
6. Add/remove repos directly from the menu bar (no config file editing)
7. Create new GitHub repos from the menu bar via GitHub CLI

## Installation

See the [main README](../README.md#-git-hatirla) for full setup instructions.

## Configuration
Open `git-hatirla.1h.sh` and set your API key:
```bash
ANTHROPIC_API_KEY="sk-ant-..."
```
Repos are managed directly from the menu bar — no need to edit the file manually.


```bash
# Add your project folders
WATCH_DIRS=(
  "/Users/yourname/Projects/repo-one"
  "/Users/yourname/Projects/repo-two"
)

# Your Anthropic API key
ANTHROPIC_API_KEY="sk-ant-..."
```

## Tech

- `bash` — core scripting
- `xbar` — menu bar rendering
- `launchd` — scheduled notifications
- `Anthropic Claude API` — commit message generation
- `osascript` — macOS native notifications
- `gh` (GitHub CLI) — new repo creation & push
