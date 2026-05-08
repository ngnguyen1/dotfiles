#!/usr/bin/env bash
set -euo pipefail

mode="${1:-down}"

get_iface() {
  local configured default_iface
  configured="$(tmux show -gv @net_speed_interfaces 2>/dev/null || true)"
  if [[ -z "$configured" || "$configured" == "auto" ]]; then
    default_iface="$(route -n get default 2>/dev/null | awk '/interface:/{print $2; exit}')"
    [[ -n "$default_iface" ]] && { echo "$default_iface"; return; }
    echo "en0"
    return
  fi
  echo "$configured" | awk '{print $1}'
}

read_bytes() {
  local iface="$1"
  if [[ -r /proc/net/dev ]]; then
    awk -F'[: ]+' -v iface="$iface" '$1==iface {print $2" "$10; exit}' /proc/net/dev
    return
  fi

  if [[ "$(uname -s)" == "Darwin" ]]; then
    netstat -bI "$iface" 2>/dev/null | awk 'NR>1 && $7 ~ /^[0-9]+$/ {rx=$7; tx=$10} END {if (rx=="") rx=0; if (tx=="") tx=0; print rx" "tx}'
    return
  fi

  echo '0 0'
}

human_rate() {
  local bytes_per_sec="$1"
  awk -v bps="$bytes_per_sec" 'BEGIN {
    if (bps >= 1073741824) printf "%.1f GB/s", bps/1073741824;
    else if (bps >= 1048576) printf "%.1f MB/s", bps/1048576;
    else if (bps >= 1024) printf "%.1f KB/s", bps/1024;
    else printf "%d B/s", bps;
  }'
}

iface="$(get_iface)"
read -r rx tx <<< "$(read_bytes "$iface")"
[[ -n "${rx:-}" ]] || rx=0
[[ -n "${tx:-}" ]] || tx=0

if [[ "$mode" == "up" ]]; then
  curr="$tx"
else
  curr="$rx"
fi

state_file="/tmp/tmux-net-rate-${iface}-${mode}.state"
now="$(date +%s)"

if [[ ! -f "$state_file" ]]; then
  printf "%s %s
" "$now" "$curr" > "$state_file"
  echo "0 B/s"
  exit 0
fi

read -r prev_t prev_v < "$state_file" || { prev_t="$now"; prev_v="$curr"; }
delta_t=$(( now - prev_t ))
(( delta_t < 1 )) && delta_t=1

if (( curr >= prev_v )); then
  delta_v=$(( curr - prev_v ))
else
  delta_v=0
fi

rate=$(( delta_v / delta_t ))
printf "%s %s
" "$now" "$curr" > "$state_file"
human_rate "$rate"
echo
echo
