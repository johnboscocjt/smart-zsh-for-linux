# Manual Setup Guide

This guide builds the working Smart Zsh setup on Arch Linux, Omarchy, or another Arch-based system using packaged software. It follows the video workflow while adapting the paths for Ghostty and avoiding GitHub plugin checkouts.

## 1. Install the foundation

Install Zsh, the completion and visual plugins, the prompt, history tool, and banner:

```sh
sudo pacman -S --needed zsh zsh-autocomplete zsh-autosuggestions \
  zsh-syntax-highlighting atuin starship fastfetch
```

Verify the packages:

```sh
pacman -Q zsh-autocomplete zsh-autosuggestions \
  zsh-syntax-highlighting atuin starship fastfetch
```

Make Zsh the login shell:

```sh
chsh -s /usr/bin/zsh
```

Log out and in if the login shell does not change immediately.

## 2. Install the font

JetBrainsMono Nerd Font is recommended because it is monospaced and contains the symbols used by Starship and Fastfetch. On Omarchy it is commonly already available. Check it with:

```sh
fc-match 'JetBrainsMono Nerd Font'
```

If it is missing, install a JetBrains Nerd Font package available from your configured Arch repositories, then refresh the font cache:

```sh
fc-cache -f
```

## 3. Configure Ghostty

Create `~/.config/ghostty/config.ghostty`:

```ini
font-family = JetBrainsMono Nerd Font
font-size = 12
background = #222222
foreground = #f2f2f2
window-padding-x = 14
window-padding-y = 12
window-decoration = false
shell-integration = none
```

The `shell-integration = none` setting is deliberate for this configuration. It prevents Ghostty's automatic Zsh startup shim from adding another startup or redraw layer. Ghostty's appearance works independently of shell integration.

Validate it:

```sh
ghostty +validate-config --config-file="$HOME/.config/ghostty/config.ghostty"
```

## 4. Configure Zsh

Copy the included `configs/zshrc` to `~/.zshrc`, or create it with this order:

```zsh
export PATH="$HOME/.local/bin:$HOME/.atuin/bin:$PATH"

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"

export ZSH_AUTOSUGGEST_STRATEGY=(history)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{cyan}%B-- %d --%b%f'
zstyle ':completion:*:messages' format '%F{magenta}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
LISTMAX=10000

command -v fastfetch >/dev/null 2>&1 && fastfetch
```

The autocomplete plugin is last because it must own the ZLE redraw hooks. Autosuggestions uses history only so it supplies grey ghost text without competing with live completion.

## 5. Configure Starship and Atuin

Copy the included files:

```sh
mkdir -p ~/.config
cp configs/starship.toml ~/.config/starship.toml
cp configs/atuin.config.toml ~/.config/atuin/config.toml
```

Atuin does not require an account. The local configuration disables synchronization and keeps history local. Press Up or Ctrl-R after running a few commands to test it.

## 6. Start the new configuration

Validate and replace the current shell:

```sh
zsh -n ~/.zshrc
exec zsh
```

For Ghostty appearance changes, close the current Ghostty window and open a new one.

## 7. Test the result

Type slowly and pause after each final character:

```sh
ls -
find /var/log -
cd /tmp/
git ch
systemctl sta
```

Expected behavior:

- `ls -` lists options such as `--almost-all`, `--directory`, and `--help` beneath the prompt.
- `find /var/log -` lists options with descriptions such as `-amin` and `-anewer`.
- `cd /tmp/` lists directories.
- `git ch` lists Git subcommands.
- `systemctl sta` lists matching subcommands.
- Up and Ctrl-R open Atuin history search.
- Syntax highlighting changes as the command becomes valid or invalid.
- A new shell prints the Fastfetch banner.

## Recovery

To disable the customization without uninstalling packages:

```sh
mv ~/.zshrc ~/.zshrc.smart-zsh
printf '%s\n' 'autoload -Uz compinit && compinit' > ~/.zshrc
exec zsh
```

To restore Smart Zsh:

```sh
cp configs/zshrc ~/.zshrc
exec zsh
```

## Important constraints

Do not source `oh-my-zsh.sh`, add a second `compinit`, or install `fzf-tab` when the goal is the live menu shown in the screenshots. Those additions can replace or wrap the same ZLE widgets and make diagnosis harder.
