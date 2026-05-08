#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" == "Darwin" ]]; then
  page_size="$(vm_stat | awk '/page size of/ {gsub("\\.","",$8); print $8; exit}')"
  active="$(vm_stat | awk -F: '/Pages active/ {gsub("\\.","",$2); gsub(/ /,"",$2); print $2; exit}')"
  wired="$(vm_stat | awk -F: '/Pages wired down/ {gsub("\\.","",$2); gsub(/ /,"",$2); print $2; exit}')"
  compressed="$(vm_stat | awk -F: '/Pages occupied by compressor/ {gsub("\\.","",$2); gsub(/ /,"",$2); print $2; exit}')"
  [[ -n "${page_size:-}" ]] || page_size=16384
  [[ -n "${active:-}" ]] || active=0
  [[ -n "${wired:-}" ]] || wired=0
  [[ -n "${compressed:-}" ]] || compressed=0

  used_bytes=$(( (active + wired + compressed) * page_size ))
  awk -v b="$used_bytes" 'BEGIN { printf "%.1fG", b/1073741824 }'
  echo
  exit 0
fi

# Linux fallback: use MemTotal - MemAvailable
if [[ -r /proc/meminfo ]]; then
  awk '
    /MemTotal:/ {total=$2}
    /MemAvailable:/ {avail=$2}
    END {
      used=(total-avail)*1024
      printf "%.1fG\n", used/1073741824
    }' /proc/meminfo
  exit 0
fi

echo "N/A"
