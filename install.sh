#!/bin/bash

echo "Starting Arch Terminal Auto-Setup..."

# 1. Update and install AUR helper (yay)
sudo pacman -Syu --needed base-devel git --noconfirm
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
fi

# 2. Install all apps from your list
if [ -f "pkglist.txt" ]; then
    yay -S --needed --noconfirm - < pkglist.txt
fi

# 3. Restore Konsole Settings
mkdir -p ~/.local/share/konsole
mkdir -p ~/.local/share/kxmlgui5/konsole
cp konsole/* ~/.local/share/konsole/
cp konsole/konsoleui.rc ~/.local/share/kxmlgui5/konsole/
cp konsolerc ~/.config/konsolerc

# 4. Restore autocommit script
mkdir -p ~/.local/bin
cp scripts/autocommit.py ~/.local/bin/autocommit
chmod +x ~/.local/bin/autocommit

# 5. Setup Zsh (Oh My Zsh + Plugins)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

echo "Done! Restart Konsole to see your themes and profiles."
