#!/usr/bin/env bash

# <xbar.title>Git Hatirla</xbar.title>
# <xbar.version>v3.0</xbar.version>
# <xbar.desc>Git commit hatirlatici</xbar.desc>

# ─── AYARLAR ───────────────────────────────────────────────
ANTHROPIC_API_KEY="buraya_api_keyin" # AI commit mesajlari icin (opsiyonel)
SCHEDULE_FILE="$HOME/.git-hatirla-schedule"
DIRS_FILE="$HOME/.git-hatirla-dirs"
PLIST_PATH="$HOME/Library/LaunchAgents/com.githatirla.reminder.plist"
SCRIPT_PATH="$HOME/Library/Application Support/xbar/plugins/git-hatirla.1h.sh"

# Dizinleri dosyadan oku, yoksa varsayılan
if [[ -f "$DIRS_FILE" ]]; then
  mapfile -t WATCH_DIRS < "$DIRS_FILE"
else
  WATCH_DIRS=(
    "/Users/yunusemre/Desktop/it-support-learning-journey"
  )
  printf '%s\n' "${WATCH_DIRS[@]}" > "$DIRS_FILE"
fi

SAVED_HOUR=$(cat "$SCHEDULE_FILE" 2>/dev/null || echo "")
# ────────────────────────────────────────────────────────────

# ─── DİZİN EKLE ─────────────────────────────────────────────
if [[ "${1:-}" == "add-dir" ]]; then
  NEW_DIR=$(osascript -e 'tell application "SystemUIServer"
    set theDir to choose folder with prompt "Git reposunu seç:"
    return POSIX path of theDir
  end tell' 2>/dev/null | sed 's|/$||')

  if [[ -z "$NEW_DIR" ]]; then
    exit 0
  fi

  # Git repo mu kontrol et
  if ! git -C "$NEW_DIR" rev-parse --git-dir > /dev/null 2>&1; then
    osascript -e "display notification \"Bu klasör bir git reposu değil!\" with title \"Git Hatırla\" sound name \"Basso\""
    exit 0
  fi

  # Zaten listede var mı?
  if grep -qx "$NEW_DIR" "$DIRS_FILE" 2>/dev/null; then
    osascript -e "display notification \"Bu klasör zaten listede.\" with title \"Git Hatırla\""
    exit 0
  fi

  echo "$NEW_DIR" >> "$DIRS_FILE"
  osascript -e "display notification \"$(basename "$NEW_DIR") eklendi! ✅\" with title \"Git Hatırla\""
  exit 0
fi

# ─── DİZİN KALDIR ───────────────────────────────────────────
if [[ "${1:-}" == "remove-dir" ]]; then
  REMOVE="${2:-}"
  grep -v "^${REMOVE}$" "$DIRS_FILE" > "$DIRS_FILE.tmp" && mv "$DIRS_FILE.tmp" "$DIRS_FILE"
  osascript -e "display notification \"$(basename "$REMOVE") listeden kaldırıldı.\" with title \"Git Hatırla\""
  exit 0
fi

# ─── YENİ REPO OLUŞTUR ──────────────────────────────────────
if [[ "${1:-}" == "new-repo" ]]; then
  # Klasör seç
  TARGET_DIR=$(osascript -e 'tell application "SystemUIServer"
    set theDir to choose folder with prompt "Repo yapılacak klasörü seç:"
    return POSIX path of theDir
  end tell' 2>/dev/null | sed 's|/$||')

  [[ -z "$TARGET_DIR" ]] && exit 0

  REPO_NAME=$(basename "$TARGET_DIR")

  # Repo adı onayla
  CONFIRMED=$(osascript -e "
    set repoName to text returned of (display dialog \"GitHub repo adı:\" default answer \"$REPO_NAME\" with title \"Git Hatırla\")
    return repoName
  " 2>/dev/null)

  [[ -z "$CONFIRMED" ]] && exit 0

  # Public mi Private mi?
  VISIBILITY=$(osascript -e '
    set vis to button returned of (display dialog "Repo görünürlüğü?" with title "Git Hatırla" buttons {"Private", "Public"} default button "Public")
    return vis
  ' 2>/dev/null | tr '[:upper:]' '[:lower:]')

  [[ -z "$VISIBILITY" ]] && VISIBILITY="public"

  # git init ve gh repo create
  cd "$TARGET_DIR" || exit 1

  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    git init
    git add -A
    git commit -m "feat: initial commit" 2>/dev/null || git commit --allow-empty -m "feat: initial commit"
  fi

  gh repo create "$CONFIRMED" "--$VISIBILITY" --source=. --remote=origin --push

  # Dizinler listesine ekle
  if ! grep -qx "$TARGET_DIR" "$DIRS_FILE" 2>/dev/null; then
    echo "$TARGET_DIR" >> "$DIRS_FILE"
  fi

  osascript -e "display notification \"$CONFIRMED GitHub'a yüklendi! 🚀\" with title \"Git Hatırla\" sound name \"Glass\""
  exit 0
fi

# ─── SAAT AYARLA ────────────────────────────────────────────
if [[ "${1:-}" == "set-hour" ]]; then
  HOUR="${2:-20}"
  echo "$HOUR" > "$SCHEDULE_FILE"
  cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.githatirla.reminder</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>${SCRIPT_PATH}</string>
    <string>notify</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Hour</key><integer>${HOUR}</integer>
    <key>Minute</key><integer>0</integer>
  </dict>
</dict>
</plist>
EOF
  launchctl unload "$PLIST_PATH" 2>/dev/null || true
  launchctl load "$PLIST_PATH"
  osascript -e "display notification \"Her gun saat ${HOUR}:00'de hatirlatacagim!\" with title \"Git Hatirla\""
  exit 0
fi

# ─── ZAMANLAMAYI KAPAT ──────────────────────────────────────
if [[ "${1:-}" == "disable" ]]; then
  launchctl unload "$PLIST_PATH" 2>/dev/null || true
  rm -f "$PLIST_PATH" "$SCHEDULE_FILE"
  osascript -e "display notification \"Zamanlama kapatildi.\" with title \"Git Hatirla\""
  exit 0
fi

# ─── BİLDİRİM ───────────────────────────────────────────────
if [[ "${1:-}" == "notify" ]]; then
  TOTAL=0
  while IFS= read -r DIR; do
    [[ -d "$DIR" ]] || continue
    cd "$DIR" 2>/dev/null || continue
    git rev-parse --git-dir > /dev/null 2>&1 || continue
    COUNT=$(( $(git diff --name-only 2>/dev/null | wc -l | tr -d ' ') + $(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ') ))
    TOTAL=$(( TOTAL + COUNT ))
  done < "$DIRS_FILE"
  if [[ $TOTAL -gt 0 ]]; then
    osascript -e "display notification \"$TOTAL bekleyen degisiklik var! Commit atmayi unutma\" with title \"Git Hatirla\" sound name \"Glass\""
  else
    osascript -e "display notification \"Her sey temiz, bugun harikasın!\" with title \"Git Hatirla\""
  fi
  exit 0
fi

# ─── COMMİT / PUSH ──────────────────────────────────────────
if [[ "${1:-}" == "commit" || "${1:-}" == "push" ]]; then
  TARGET_DIR="${2:-}"
  cd "$TARGET_DIR" || exit 1
  echo "==================================="
  echo "  Git Hatirla - $(basename "$TARGET_DIR")"
  echo "==================================="
  git status --short
  echo ""
  git add -A
  echo "Tum degisiklikler stage'e alindi."
  echo ""
  if [[ -n "$ANTHROPIC_API_KEY" && "$ANTHROPIC_API_KEY" != "buraya_api_keyin" ]]; then
    echo "AI commit mesaji olusturuyor..."
    DIFF_STAT=$(git diff --cached --stat 2>/dev/null)
    DIFF_DETAIL=$(git diff --cached 2>/dev/null | head -c 2000)
    AI_MSG=$(curl -s https://api.anthropic.com/v1/messages \
      -H "x-api-key: $ANTHROPIC_API_KEY" \
      -H "anthropic-version: 2023-06-01" \
      -H "content-type: application/json" \
      -d "{\"model\":\"claude-sonnet-4-20250514\",\"max_tokens\":200,\"messages\":[{\"role\":\"user\",\"content\":\"Git diff'e bakarak kisa commit mesaji yaz. Conventional commits (feat:, fix:, docs: vb). Sadece mesaji yaz.\n\n$DIFF_STAT\n\n$DIFF_DETAIL\"}]}" \
      | python3 -c "import sys,json
try:
  d=json.load(sys.stdin)
  print(d['content'][0]['text'].strip())
except: print('')" 2>/dev/null)
    echo "AI onerisi: $AI_MSG"
    echo ""
    read -rp "Kullan (Enter) veya kendi mesajini yaz: " USER_MSG
    COMMIT_MSG="${USER_MSG:-$AI_MSG}"
  else
    read -rp "Commit mesaji: " COMMIT_MSG
  fi
  [[ -z "$COMMIT_MSG" ]] && { echo "Iptal edildi."; exit 0; }
  git commit -m "$COMMIT_MSG"
  echo "Commit atildi!"
  if [[ "${1:-}" == "push" ]]; then
    BRANCH=$(git branch --show-current)
    git push origin "$BRANCH"
    echo "Push basarili!"
  fi
  read -rp "Kapatmak icin Enter'a bas..." _
  exit 0
fi

# ─── MENÜ ÇIKTISI ───────────────────────────────────────────
MENU=""
TOTAL_DIRTY=0

while IFS= read -r DIR; do
  [[ -d "$DIR" ]] || continue
  cd "$DIR" 2>/dev/null || continue
  git rev-parse --git-dir > /dev/null 2>&1 || continue

  REPO=$(basename "$DIR")
  BRANCH=$(git branch --show-current 2>/dev/null || echo "?")
  LAST=$(git log -1 --format="%cr" 2>/dev/null || echo "hic commit yok")
  UNSTAGED=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  TOTAL=$(( UNSTAGED + UNTRACKED ))
  TOTAL_DIRTY=$(( TOTAL_DIRTY + TOTAL ))

  if [[ $TOTAL -gt 0 ]]; then
    MENU+="⚡ $REPO ($TOTAL degisiklik) | color=#FF6B35 font=bold\n"
  else
    MENU+="✅ $REPO | color=#30D158 font=bold\n"
  fi
  MENU+="-- 🌿 Branch: $BRANCH | color=#888888\n"
  MENU+="-- ⏰ Son commit: $LAST | color=#888888\n"
  if [[ $TOTAL -gt 0 ]]; then
    MENU+="-- ---\n"
    MENU+="-- 🤖 AI ile Commit At | bash='$SCRIPT_PATH' param1=commit param2='$DIR' terminal=true\n"
    MENU+="-- 🚀 Commit + Push    | bash='$SCRIPT_PATH' param1=push   param2='$DIR' terminal=true\n"
  else
    MENU+="-- Bekleyen degisiklik yok\n"
  fi
  MENU+="-- ✕ Listeden Kaldir  | bash='$SCRIPT_PATH' param1=remove-dir param2='$DIR' terminal=false refresh=true\n"
  MENU+="---\n"
done < "$DIRS_FILE"

# Menu bar ikonu
if [[ $TOTAL_DIRTY -gt 0 ]]; then
  echo "⚡ git"
else
  echo "✅ git"
fi

echo "---"
echo "Git Hatirla | font=bold"
echo "---"

if [[ -z "$MENU" ]]; then
  echo "Hic proje bulunamadi"
else
  echo -e "$MENU"
fi

# Dizin yönetimi
echo "---"
echo "📁 Dizin Yonet | font=bold"
echo "-- ➕ Mevcut Repo Ekle    | bash='$SCRIPT_PATH' param1=add-dir terminal=false refresh=true"
echo "-- 🆕 Yeni Repo Olustur   | bash='$SCRIPT_PATH' param1=new-repo terminal=false refresh=true"

# Hatırlatma saati
echo "---"
echo "🔔 Hatirlatma Saati | font=bold"
if [[ -n "$SAVED_HOUR" ]]; then
  echo "-- ✅ Aktif: Her gun saat $SAVED_HOUR:00 | color=#30D158"
  echo "-- ---"
else
  echo "-- Henuz ayarlanmadi"
  echo "-- ---"
fi
for H in 09 10 11 12 13 14 15 16 17 18 19 20 21 22; do
  if [[ "$H" == "$SAVED_HOUR" ]]; then
    echo "-- ● $H:00 ✓ | bash='$SCRIPT_PATH' param1=set-hour param2=$H terminal=false refresh=true"
  else
    echo "-- ○ $H:00   | bash='$SCRIPT_PATH' param1=set-hour param2=$H terminal=false refresh=true"
  fi
done
echo "-- ---"
echo "-- ❌ Zamanlamayi Kapat | bash='$SCRIPT_PATH' param1=disable terminal=false refresh=true"
echo "---"
echo "🔄 Yenile | refresh=true"
echo "📝 Scripti Duzenle | bash=open param1=-a param2=TextEdit param3='$SCRIPT_PATH' terminal=false"