#!/usr/bin/env bash
# ── Screenshot to Google Lens ────────────────────────
tmp="/tmp/lens-$(date +%s).png"
grim -g "$(slurp)" "$tmp" && \
    brave --new-window "https://lens.google.com/upload?ep=ccm&s=&st=$(date +%s)" &
sleep 1
xdg-open "$tmp" 2>/dev/null || \
    brave "https://lens.google.com/"
