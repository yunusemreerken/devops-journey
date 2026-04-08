# 🛠️ devops-journey

> A growing collection of automation tools built along my IT Support → SysAdmin → DevOps path.
> Each tool solves a real problem I faced on the job — scripted, automated, and open source.

---

## 🚀 Tools

| Tool | Description | Platform |
|------|-------------|----------|
| [git-hatirla](./git-hatirla/) | AI-powered Git commit reminder in your macOS menu bar | macOS |
| [kubernetes-setup-linux-server](./kubernetes-setup-linux-server/) | Install your kubernetes cluster on ubuntu server with one command | Ubuntu |
| *More coming soon...* | Ticket automation, disk monitoring, health checks | - |

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
)

ANTHROPIC_API_KEY="sk-ant-..."
```

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

## 📍 Roadmap

- [ ] `ticket-helper` — Create GitHub Issues from the terminal with AI-generated titles and labels
- [ ] `disk-watch` — Monitor disk usage and get notified before it's too late
- [ ] `health-check` — Ping servers, check ports and HTTP endpoints
- [ ] `cert-watch` — SSL certificate expiry tracker with early warnings
- [ ] `log-cleaner` — Auto-clean old logs with a summary report

---

## 🧑‍💻 About

I'm on the IT Support → SysAdmin → DevOps path. Instead of just learning theory, I build tools that solve real problems I run into every day. This repo is where those tools live.

---

## 📄 License

MIT — use it, fork it, improve it.