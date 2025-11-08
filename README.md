https://github.com/user-attachments/assets/ae94545f-1c08-48c5-8d09-4fce44346967

### Tested on a fresh Omarchy 3.1.5.

```bash
git clone https://github.com/ryrobes/omarchy-theme-generate.git
cd omarchy-theme-generate
./install.sh
```

** Updates Hyprland, Zed, GTK3/4, VSCode, Obsidian, Kitty, Alacritty, Chromium, etc. **

(Note: Most GTK apps need to be restarted for the theme to take effect, ex: Nautilus)

Give it a background image or folder of images and it will select one at random to base the theme off of. The theme generated will be in your theme list as "Dynamic", and will be replaced each time it is run (unless you run it manually with a diff name, see below).

Adds a "Theme Generator" App to Omarchy's app menu, select a folder/image and your theme will be generated and changed.

*Also has CLI to generate theme files without changing. See `omarchy-theme-generate --help`.*

