https://github.com/user-attachments/assets/ae94545f-1c08-48c5-8d09-4fce44346967

### Tested on a fresh Omarchy 3.1.6.

```bash
git clone https://github.com/ryrobes/omarchy-theme-generate.git
##or: gh repo clone ryrobes/omarchy-theme-generate
cd omarchy-theme-generate
./install.sh
```

Super-Space for the Omarchy menu, search for Theme Generator, choose a folder/image. Go. Will generate a 'dynamic' theme and swap to it.

Submitted as a PR to core Omarchy here: https://github.com/basecamp/omarchy/pull/3210 - but can be installed on top in case they aren't interested - will keep it up to date for each release in the meantime.

> Updates Hyprland, *Zed*, *GTK3/4*, VSCode, Obsidian, Kitty, Alacritty, Chromium, etc.

_Note: Most GTK apps need to be restarted for the theme to take effect, ex: Nautilus. However GTK css is a funky mess and still a WIP_

Give it a background image or folder of images and it will select one at random to base the theme off of. The theme generated will be in your theme list as "Dynamic", and will be replaced each time it is run (unless you run it manually with a diff name, see below).

Adds a "Theme Generator" App to Omarchy's app menu, select a folder/image and your theme will be generated and changed.

*Also has CLI to generate theme files without changing. See `omarchy-theme-generate --help`.*

```
~ ❯ omarchy-theme-generate --help
Omarchy Theme Generator
Generates a complete desktop theme from an input image

Usage:
  omarchy-theme-generate <input-image-or-directory> [theme-name]
  omarchy-theme-generate --walker
  omarchy-theme-generate --help

Arguments:
  input-image-or-directory  Path to an image file OR directory containing images
                            If directory, a random image will be selected
  theme-name                Name for the generated theme (default: "generated")

Options:
  --walker                  Launch interactive UI to select image folder
  --refresh-cache           Rebuild the walker folder cache (can combine with --walker)
  --help, -h                Show this help message

Environment Variables:
  OMARCHY_DEPLOY=0          Disable deployment to ~/.config/omarchy/themes/ (default: 1)
  OMARCHY_SET=0             Skip running omarchy-theme-set after deployment (default: 1)
  OMARCHY_TEMPLATE_DIR      Use custom template directory instead of embedded

Examples:
  # Generate from specific image
  omarchy-theme-generate ~/Pictures/wallpaper.jpg sunset

  # Generate from random image in directory
  omarchy-theme-generate ~/Pictures/wallpapers beach

  # Launch interactive folder picker
  omarchy-theme-generate --walker

  # Refresh the folder cache and launch picker
  omarchy-theme-generate --refresh-cache --walker

  # Just refresh the cache (for faster subsequent --walker calls)
  omarchy-theme-generate --refresh-cache

  # Generate without deploying or setting theme
  OMARCHY_DEPLOY=0 OMARCHY_SET=0 omarchy-theme-generate image.png test
```

Generates a theme like this:
```
~ ✗ ls ~/.config/omarchy/themes/{dynamic} # or whatever you manually call it as
Permissions Size User  Date Modified Name
drwxr-xr-x     - ryanr  9 Nov 00:02   backgrounds
.rw-r--r--   834 ryanr  9 Nov 00:02   alacritty.toml
.rw-r--r--  1.7k ryanr  9 Nov 00:02   btop.theme
.rw-r--r--     9 ryanr  9 Nov 00:02   chromium.theme
.rw-r--r--    50 ryanr  9 Nov 00:02   fonts.json
.rw-r--r--   440 ryanr  9 Nov 00:02  󰡯 ghostty-theme
.rwxr-xr-x   721 ryanr  9 Nov 00:02  󱁻 ghostty.conf
.rw-r--r--   225 ryanr  9 Nov 00:02   hyprland.conf
.rw-r--r--   209 ryanr  9 Nov 00:02   hyprlock.conf
.rw-r--r--    10 ryanr  9 Nov 00:02   icons.theme
.rw-r--r--  1.3k ryanr  9 Nov 00:02  󱁻 kitty.conf
.rw-r--r--   346 ryanr  9 Nov 00:02  󱁻 mako.ini
.rwxr-xr-x  1.2k ryanr  9 Nov 00:02   neovim.lua
.rw-r--r--   166 ryanr  9 Nov 00:02   swayosd.css
.rw-r--r--   191 ryanr  9 Nov 00:02   walker.css
.rw-r--r--    68 ryanr  9 Nov 00:02   waybar.css

~ ❯ ls ~/.config/omarchy/themes/{dynamic}/backgrounds/
Permissions Size User  Date Modified Name
.rw-r--r--  4.2M ryanr  9 Nov 00:02   wallpaper.webp
```


