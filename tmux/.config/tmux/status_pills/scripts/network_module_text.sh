#!/usr/bin/env bash
# Builds the full network pill text (same layout as before) and pads to a fixed
# width so the whole module does not shift when rates change.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Total width of the text segment (space + ↑ + rate + ↓ + rate), pad with spaces on the right.
: "${NETWORK_MODULE_TEXT_WIDTH:=46}"

up="$("$SCRIPT_DIR/net_rate.sh" up)"
down="$("$SCRIPT_DIR/net_rate.sh" down)"
up="${up//$'\n'/}"
down="${down//$'\n'/}"

line=" ↑ ${up} ↓ ${down}"
if ((${#line} > NETWORK_MODULE_TEXT_WIDTH)); then
  line="${line:0:NETWORK_MODULE_TEXT_WIDTH}"
fi
printf '%-*s\n' "$NETWORK_MODULE_TEXT_WIDTH" "$line"
