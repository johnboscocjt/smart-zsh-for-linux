#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
PACKAGES=(
  zsh
  zsh-autocomplete
  zsh-autosuggestions
  zsh-syntax-highlighting
  atuin
  starship
  fastfetch
)

usage() {
  cat <<'EOF'
Usage: ./setup.sh [command]

Commands:
  all       Install packages, copy configs, set Zsh, and verify (default)
  packages  Install the Arch packages used by Smart Zsh
  configs   Copy repository configs into the home directory
  shell     Make /usr/bin/zsh the login shell
  verify    Validate commands, Zsh syntax, and Ghostty config
  help      Show this help

Examples:
  ./setup.sh
  ./setup.sh all
  ./setup.sh packages
  ./setup.sh configs
  ./setup.sh verify
EOF
}

need_arch() {
  if [[ ! -r /etc/arch-release ]] || ! command -v pacman >/dev/null 2>&1; then
    printf '%s\n' 'This script requires Arch Linux or Omarchy with pacman.' >&2
    exit 1
  fi
}

as_root() {
  if (( EUID == 0 )); then
    "$@"
  else
    sudo "$@"
  fi
}

install_packages() {
  need_arch
  as_root pacman -S --needed "${PACKAGES[@]}"
}

install_configs() {
  mkdir -p "$HOME/.config/ghostty" "$HOME/.config/atuin"
  install -Dm644 "$ROOT_DIR/configs/zshrc" "$HOME/.zshrc"
  install -Dm644 "$ROOT_DIR/configs/ghostty.config" "$HOME/.config/ghostty/config.ghostty"
  install -Dm644 "$ROOT_DIR/configs/starship.toml" "$HOME/.config/starship.toml"
  install -Dm644 "$ROOT_DIR/configs/atuin.config.toml" "$HOME/.config/atuin/config.toml"
  printf '%s\n' 'Installed Smart Zsh configuration files.'
}

set_shell() {
  command -v chsh >/dev/null 2>&1 || {
    printf '%s\n' 'chsh is required to change the login shell.' >&2
    exit 1
  }
  chsh -s /usr/bin/zsh "$USER"
}

verify() {
  local command_name
  local failed=0
  for command_name in zsh starship atuin fastfetch ghostty; do
    if command -v "$command_name" >/dev/null 2>&1; then
      printf 'found: %s -> %s\n' "$command_name" "$(command -v "$command_name")"
    else
      printf 'missing: %s\n' "$command_name" >&2
      failed=1
    fi
  done

  if [[ -r "$HOME/.zshrc" ]] && zsh -n "$HOME/.zshrc"; then
    printf '%s\n' 'Zsh syntax: PASS'
  else
    printf '%s\n' 'Zsh syntax: FAIL' >&2
    failed=1
  fi

  if [[ -r "$HOME/.config/ghostty/config.ghostty" ]] && ghostty +validate-config \
      --config-file="$HOME/.config/ghostty/config.ghostty" >/dev/null; then
    printf '%s\n' 'Ghostty config: PASS'
  else
    printf '%s\n' 'Ghostty config: FAIL' >&2
    failed=1
  fi

  return "$failed"
}

main() {
  local command_name=${1:-all}
  case "$command_name" in
    all)
      install_packages
      install_configs
      set_shell
      verify
      ;;
    packages)
      install_packages
      ;;
    configs)
      install_configs
      ;;
    shell)
      set_shell
      ;;
    verify)
      verify
      ;;
    help|-h|--help)
      usage
      ;;
    *)
      printf 'Unknown command: %s\n\n' "$command_name" >&2
      usage >&2
      exit 2
      ;;
  esac
}

main "$@"
