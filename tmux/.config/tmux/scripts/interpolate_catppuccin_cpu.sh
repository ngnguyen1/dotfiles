#!/usr/bin/env bash
# Replace #{cpu_*} placeholders inside @catppuccin_status_cpu with tmux-cpu script
# commands. tmux-cpu/cpu.tmux only rewrites status-right/status-left; catppuccin
# keeps #{cpu_percentage} inside user options, so we apply the same mapping here.
#
# Keep interpolation lists in sync with tmux-plugins/tmux-cpu/cpu.tmux.

set -euo pipefail

ROOT="${TMUX_PLUGIN_MANAGER_PATH:-${HOME}/.tmux/plugins}"
ROOT="${ROOT%/}"
CURRENT_DIR="${ROOT}/tmux-cpu"
if [[ ! -d "${CURRENT_DIR}" ]]; then
  CURRENT_DIR="${HOME}/.config/tmux/plugins/tmux-cpu"
fi
if [[ ! -d "${CURRENT_DIR}" ]]; then
  exit 0
fi

source "${CURRENT_DIR}/scripts/helpers.sh"

cpu_interpolation=(
  "\#{cpu_percentage}"
  "\#{cpu_icon}"
  "\#{cpu_bg_color}"
  "\#{cpu_fg_color}"
  "\#{gpu_percentage}"
  "\#{gpu_icon}"
  "\#{gpu_bg_color}"
  "\#{gpu_fg_color}"
  "\#{ram_percentage}"
  "\#{ram_icon}"
  "\#{ram_bg_color}"
  "\#{ram_fg_color}"
  "\#{gram_percentage}"
  "\#{gram_icon}"
  "\#{gram_bg_color}"
  "\#{gram_fg_color}"
  "\#{cpu_temp}"
  "\#{cpu_temp_icon}"
  "\#{cpu_temp_bg_color}"
  "\#{cpu_temp_fg_color}"
  "\#{gpu_temp}"
  "\#{gpu_temp_icon}"
  "\#{gpu_temp_bg_color}"
  "\#{gpu_temp_fg_color}"
)
cpu_commands=(
  "#(${CURRENT_DIR}/scripts/cpu_percentage.sh)"
  "#(${CURRENT_DIR}/scripts/cpu_icon.sh)"
  "#(${CURRENT_DIR}/scripts/cpu_bg_color.sh)"
  "#(${CURRENT_DIR}/scripts/cpu_fg_color.sh)"
  "#(${CURRENT_DIR}/scripts/gpu_percentage.sh)"
  "#(${CURRENT_DIR}/scripts/gpu_icon.sh)"
  "#(${CURRENT_DIR}/scripts/gpu_bg_color.sh)"
  "#(${CURRENT_DIR}/scripts/gpu_fg_color.sh)"
  "#(${CURRENT_DIR}/scripts/ram_percentage.sh)"
  "#(${CURRENT_DIR}/scripts/ram_icon.sh)"
  "#(${CURRENT_DIR}/scripts/ram_bg_color.sh)"
  "#(${CURRENT_DIR}/scripts/ram_fg_color.sh)"
  "#(${CURRENT_DIR}/scripts/gram_percentage.sh)"
  "#(${CURRENT_DIR}/scripts/gram_icon.sh)"
  "#(${CURRENT_DIR}/scripts/gram_bg_color.sh)"
  "#(${CURRENT_DIR}/scripts/gram_fg_color.sh)"
  "#(${CURRENT_DIR}/scripts/cpu_temp.sh)"
  "#(${CURRENT_DIR}/scripts/cpu_temp_icon.sh)"
  "#(${CURRENT_DIR}/scripts/cpu_temp_bg_color.sh)"
  "#(${CURRENT_DIR}/scripts/cpu_temp_fg_color.sh)"
  "#(${CURRENT_DIR}/scripts/gpu_temp.sh)"
  "#(${CURRENT_DIR}/scripts/gpu_temp_icon.sh)"
  "#(${CURRENT_DIR}/scripts/gpu_temp_bg_color.sh)"
  "#(${CURRENT_DIR}/scripts/gpu_temp_fg_color.sh)"
)

set_tmux_option() {
  tmux set-option -gq "$1" "$2"
}

do_interpolation() {
  local all_interpolated="$1"
  local i
  for ((i = 0; i < ${#cpu_commands[@]}; i++)); do
    all_interpolated=${all_interpolated//${cpu_interpolation[$i]}/${cpu_commands[$i]}}
  done
  echo "${all_interpolated}"
}

option_value="$(get_tmux_option "@catppuccin_status_cpu" "")"
if [[ -n "${option_value}" ]]; then
  new_value="$(do_interpolation "${option_value}")"
  set_tmux_option "@catppuccin_status_cpu" "${new_value}"
fi

option_value="$(get_tmux_option "@catppuccin_cpu_text" "")"
if [[ -n "${option_value}" ]]; then
  new_value="$(do_interpolation "${option_value}")"
  set_tmux_option "@catppuccin_cpu_text" "${new_value}"
fi
