#!/usr/bin/env bash
# Build the LaunchAgent helper and register it (macOS).
set -euo pipefail

readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly listener_out="${HOME}/.config/theme-reload/theme-listener"
readonly label="com.ngnguyen.theme-reload"
readonly plist_dst="${HOME}/Library/LaunchAgents/${label}.plist"

swiftc -O "${script_dir}/listener.swift" -o "${listener_out}"
chmod +x "${listener_out}"

sed "s|__HOME__|${HOME}|g" "${script_dir}/${label}.plist.in" > "${plist_dst}"

launchctl bootout "gui/$(id -u)/${label}" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "${plist_dst}"

echo "Installed ${listener_out} and ${plist_dst}. Service label: ${label}"
