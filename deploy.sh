#!/bin/zsh
# Agent Radio — push the freshest build to GitHub Pages
set -e
SRC="${1:-/private/tmp/claude-502/-Users-marcecko/a8ed4606-a4f1-4f72-adb6-f98246243022/scratchpad}"
cd "$(dirname "$0")"
cp "$SRC/agent-radio.html" demo/index.html
cp "$SRC/agent-radio-prd.html" prd/index.html
# public PRD points at the public demo, not the private artifact
perl -pi -e 's|https://claude\.ai/code/artifact/b87eca2d-c152-49fb-9602-1c67e9366de6|../demo/|g' prd/index.html
# encrypt behind the share password (browser-side AES-GCM decrypt)
PW="${AR_PW:-$(cat .arpw 2>/dev/null)}"
[ -n "$PW" ] || { echo "set AR_PW or put the password in .arpw (untracked)"; exit 1; }
python3 encrypt.py "$PW" demo/index.html prd/index.html
git add -A && git commit -m "publish wave $(date +%Y-%m-%d-%H%M)" && git push
