#!/usr/bin/env bash
set -euo pipefail

############################################
# Arch system setup script
############################################
USERNAME=$(logname)
USER_HOME="/home/$USERNAME"

############################################
# System update
############################################
echo "==> Updating system..."
pacman -Syyu --noconfirm

############################################
# Core packages
############################################
echo "==> Installing core packages..."

pacman -S --needed --noconfirm \
7zip amd-ucode aria2 base-devel bitwarden blanket \
blueman brightnessctl btrfs-progs cloudflared cmake copyq \
dart-sass docker docker-compose dotnet-sdk-8.0 fastfetch fzf \
geeqie ghostty git grimblast-git grub gvfs htop hyprland hyprlock \
hyprpaper hyprpicker hyprpolkitagent hyprshot imagemagick \
lazydocker lazygit libreoffice-fresh luarocks lynis meson mpv \
neovim networkmanager noisetorch noto-fonts noto-fonts-cjk \
noto-fonts-emoji noto-fonts-extra nwg-look obs-studio obsidian \
pacman-contrib papirus-icon-theme pipewire python-pyqt6 qbittorrent \
qt6-shadertools qt6-tools reflector rofi starship steam swaync \
swww tailscale tealdeer terminus-font \
thunderbird ttf-cascadia-code ttf-liberation ueberzugpp unrar unzip \
vlc vulkan-tools waybar waypaper wget wine winetricks wiremix \
yazi yt-dlp zip zram-generator zsh \
linux-cachyos linux-cachyos-headers \
cachyos-kernel-manager cachyos-keyring cachyos-mirrorlist \
discord btop zen-browser-bin

############################################
# Enable essential services
############################################
echo "==> Enabling services..."
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
systemctl enable docker.service

############################################
# Paru installation
############################################
echo "==> Installing paru (AUR helper)..."

if ! command -v paru &>/dev/null; then
  PARU_DIR="$USER_HOME/paru"

  sudo -u "$USERNAME" git clone https://aur.archlinux.org/paru.git "$PARU_DIR"

  sudo -u "$USERNAME" bash <<EOF
cd "$PARU_DIR"
makepkg -si --noconfirm
EOF

  rm -rf "$PARU_DIR"
else
  echo "paru already installed"
fi

############################################
# AUR packages via paru
############################################
echo "==> Installing AUR packages..."

sudo -u "$USERNAME" paru -S --needed --noconfirm \
aylurs-gtk-shell-git \
bibata-cursor-theme \
blender-launcher-v2-bin \
catppuccin-gtk-theme-mocha \
filen-desktop-bin \
getnf \
libtiff5 \
matugen-bin \
noesis-bin \
pixelorama \
pureref \
wf-recorder-git

############################################
# Copy dotfiles to ~/.config
############################################
echo "==> Copying config files..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="$SCRIPT_DIR/configs"
CONFIG_DEST="/home/$USERNAME/.config"

# Ensure destination exists
mkdir -p "$CONFIG_DEST"

# Copy everything
cp -rT "$CONFIG_SRC" "$CONFIG_DEST"

# Fix ownership
chown -R "$USERNAME:$USERNAME" "$CONFIG_DEST"

############################################
# Zsh setup
############################################
echo "==> Installing and setting zsh as default shell..."

# Ensure zsh is installed
pacman -S --needed --noconfirm zsh

# Change default shell for the user
if [[ "$(getent passwd "$USERNAME" | cut -d: -f7)" != "/bin/zsh" ]]; then
  chsh -s /bin/zsh "$USERNAME"
  echo "Default shell changed to zsh for $USERNAME"
else
  echo "zsh is already the default shell for $USERNAME"
fi

############################################
# Install user's .zshrc
############################################
echo "==> Installing .zshrc..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC_SRC="$SCRIPT_DIR/.zshrc"
ZSHRC_DEST="/home/$USERNAME/.zshrc"

if [[ -f "$ZSHRC_SRC" ]]; then
  cp "$ZSHRC_SRC" "$ZSHRC_DEST"
  chown "$USERNAME:$USERNAME" "$ZSHRC_DEST"
  chmod 644 "$ZSHRC_DEST"
  echo ".zshrc installed successfully"
else
  echo "WARNING: .zshrc not found in script directory"
fi

############################################
# Done
############################################
echo "========================================"
echo " Installation complete!"
echo " You may want to reboot now."
echo "========================================"

