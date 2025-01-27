#!/bin/bash

# Save rep dir
REP_DIR=$PWD

# Installing pkgs
echo "Installing pkgs..."
sudo pacman -Suy --noconfirm --needed $(< pkgslist.txt)

# Installing Rust
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
rustup override set stable
rustup update stable

# Installing yay/AUR
echo "Installing AUR (yay)..."
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay/

# Cloning repositories
echo "Cloning dwm, slstatus, and others..."
mkdir -p ~/wm
git clone https://git.suckless.org/dwm ~/wm/dwm
git clone https://git.suckless.org/slstatus ~/wm/slstatus
git clone https://git.suckless.org/dmenu ~/wm/dmenu
git clone https://github.com/alacritty/alacritty.git ~/wm/alacritty

# Compile Alacritty
echo "Compiling Alacritty..."
cd ~/wm/alacritty
cargo build --release
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
cd "$REP_DIR"
cp alacritty/alacritty.toml ~/.config/alacritty

# Compile dwm
echo "Compiling dwm..."
if [ ! -f dwm/config.h ] || [ ! -f dwm/dwm.c ]; then
    echo "Error: Missing dwm config files!"
    exit 1
fi
cp dwm/config.h dwm/dwm.c ~/wm/dwm
cp dwm/wallpeper.png ~/wm/dwm 2>/dev/null || echo "Warning: wallpeper.png not found."
cp scripts/brightness_status.sh scripts/volume_status.sh ~/wm/dwm
cd ~/wm/dwm
make
sudo make install
cd "$REP_DIR"

# Compile slstatus
echo "Compiling slstatus..."
cp slstatus/config.h ~/wm/slstatus
cd ~/wm/slstatus
make
sudo make install
cd "$REP_DIR"

# Compile dmenu
echo "Compiling dmenu..."
cd ~/wm/dmenu
make
sudo make install
cd "$REP_DIR"

# Installing Zsh + Oh My Zsh + Powerlevel10k
echo "Installing Zsh + Oh My Zsh + Powerlevel10k..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
chsh -s "$(which zsh)"

# Copying scripts and configs
echo "Copying configurations..."
mkdir -p ~/.scripts
cp scripts/startdwm.sh ~/.scripts
cp .xinitrc ~/

echo -e "\nInstallation complete! I recommend rebooting the device."

