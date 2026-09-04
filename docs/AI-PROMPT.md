# AI Prompt: Recreate Smart Zsh for Linux

Copy the prompt below into a coding agent running on the target Linux machine.

```text
You are configuring a real Arch Linux or Omarchy desktop for Ghostty. Build a polished, reliable terminal setup inspired by the referenced Linux terminal customization video.

Goal:
- Use /usr/bin/zsh as the interactive shell.
- Use Ghostty with JetBrainsMono Nerd Font, 12pt, #222222 background, light foreground, padding, and no window decoration.
- Show a Starship prompt with OS, username, directory, Git state, time, and useful language modules.
- Show a Fastfetch banner at shell startup.
- Use Atuin for local fuzzy history search on Up and Ctrl-R.
- Show grey history-based autosuggestions.
- Show green/red syntax highlighting.
- Show live, as-you-type completion below the prompt with no Tab press. Examples must include `ls -`, `find /var/log -`, `cd /tmp/`, `git ch`, and `systemctl sta`.

Hard constraints:
1. Work on Arch/Omarchy and use pacman packages where available.
2. Do not clone plugin repositories from GitHub.
3. Do not use Kitty-specific completion behavior; the daily terminal is Ghostty.
4. Do not source oh-my-zsh.sh.
5. Do not add a second compinit call.
6. Do not add fzf-tab; it is Tab-triggered and is not the requested live menu.
7. Preserve unrelated user configuration unless the user explicitly asks for a reset.
8. Inspect ~/.config/ghostty/config.ghostty before editing it.
9. Never put passwords, tokens, or secrets in files, commands, logs, or commits.

Install if missing:
  sudo pacman -S --needed zsh zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting atuin starship fastfetch

Use these Arch package paths:
  /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

Write ~/.zshrc in this exact order:
1. PATH additions for ~/.local/bin and ~/.atuin/bin.
2. `eval "$(starship init zsh)"`.
3. `eval "$(atuin init zsh)"`.
4. Set `ZSH_AUTOSUGGEST_STRATEGY=(history)` and source autosuggestions.
5. Source syntax highlighting.
6. Source zsh-autocomplete last.
7. Add completion descriptions, group-name, menu select, and LISTMAX=10000.
8. Run fastfetch only when the command exists.

For Ghostty, use:
  font-family = JetBrainsMono Nerd Font
  font-size = 12
  background = #222222
  foreground = #f2f2f2
  window-padding-x = 14
  window-padding-y = 12
  window-decoration = false
  shell-integration = none

Validation is mandatory before claiming success:
- Run `zsh -n ~/.zshrc`.
- Run `ghostty +validate-config --config-file="$HOME/.config/ghostty/config.ghostty"`.
- Start a fresh interactive Zsh in a PTY with TERM=xterm-ghostty.
- Simulate character-by-character input for `ls -` and verify output contains `--almost-all`, `--directory`, or `--help`.
- Verify `whence -w _zsh_autosuggest_modify _zsh_highlight`.
- Verify `command -v starship atuin fastfetch`.
- Report any failing check honestly.
- Restart Ghostty only after validation passes.

Keep the edits minimal, show the exact files changed, and explain any package or terminal-specific adaptation.
```

## Why This Prompt Works

It identifies the key ownership boundary: autosuggestions provides history text, while autocomplete owns the completion redraw path. It also makes the package paths explicit for Arch and requires an executable behavior test instead of relying on startup inspection alone.
