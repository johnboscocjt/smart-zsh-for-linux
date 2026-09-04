# Feature Reference

## Prompt

Starship renders a segmented prompt using the existing `~/.config/starship.toml`. It shows the operating system icon, username, current directory, Git branch/status, detected language environments, and current time. The prompt uses a Gruvbox-inspired palette and Nerd Font glyphs.

## Live completion

`zsh-autocomplete` runs the standard Zsh completion system asynchronously as the line changes. It is loaded last so its completion and redraw widgets remain in control. Completion descriptions are formatted in cyan, messages in magenta, and warnings in red.

Examples:

```text
ls -
--almost-all       -A  -- list all except . and ..
--directory        -d  -- list directory entries instead of contents

find /var/log -
-amin              -- access time (minutes)
-anewer            -- file to compare (access time)
-Bmin              -- birth time (minutes)
```

The menu is live; it does not require pressing Tab. Tab remains available for accepting or navigating a completion.

## Autosuggestions

`zsh-autosuggestions` uses the `history` strategy. Existing commands can appear as muted grey text after the cursor. Completion is intentionally excluded from its strategy so it does not compete with `zsh-autocomplete` for the same redraw surface.

## Syntax highlighting

`zsh-syntax-highlighting` runs after the command line changes. Valid command structures and invalid text receive different colors according to the plugin defaults and terminal palette.

## Atuin

Atuin stores command history in a local database and adds searchable history UI to Up and Ctrl-R. The included config uses fuzzy search, compact display, a 20-line inline view, previews, and no synchronization.

## Fastfetch

Fastfetch runs once from `.zshrc` when available, displaying the hardware, OS, kernel, desktop, terminal, font, storage, memory, and uptime information visible in the screenshots.

## Ghostty appearance

The Ghostty config uses JetBrainsMono Nerd Font at 12pt, a dark `#222222` background, light foreground, padding, and hidden window decoration. `shell-integration = none` keeps Ghostty's optional Zsh injection out of the ZLE plugin stack.

## Design decisions

- Arch packages are preferred over GitHub checkouts.
- No framework is sourced; the config uses direct package entrypoints.
- No manual `compinit` is called because autocomplete owns completion initialization.
- No fzf-tab is used because it requires a completion keypress instead of providing the requested live menu.
- The configuration remains plain text and can be audited or removed easily.
