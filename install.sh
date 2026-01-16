#!/bin/bash

echo "Starting Arch Terminal Auto-Setup..."

# 1. Update and install AUR helper (yay)
sudo pacman -Syu --needed base-devel git --noconfirm
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
fi

# 2. Install all apps from your list
if [ -f "pkglist.txt" ]; then
    echo "Installing packages..."
    yay -S --needed --noconfirm - < pkglist.txt
fi

# 3. Restore Konsole Settings
echo "Restoring Konsole profiles and themes..."
mkdir -p ~/.local/share/konsole
mkdir -p ~/.local/share/kxmlgui5/konsole
cp konsole/* ~/.local/share/konsole/ 2>/dev/null
cp konsole/konsoleui.rc ~/.local/share/kxmlgui5/konsole/ 2>/dev/null
cp konsolerc ~/.config/konsolerc 2>/dev/null

# 4. Restore autocommit script
echo "Restoring custom scripts..."
mkdir -p ~/.local/bin
cp scripts/autocommit.py ~/.local/bin/autocommit
chmod +x ~/.local/bin/autocommit

# 5. Setup Zsh (Oh My Zsh + Plugins)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Clone plugins if they don't exist
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# 6. Restore .zshrc
echo "Applying .zshrc configuration..."
cp .zshrc ~/.zshrc

echo "Setup Complete! Please restart Konsole."
