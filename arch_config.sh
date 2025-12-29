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
swww tailscale tealdeer terminus-font thunar thunar-archive-plugin \
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
# Done
############################################
echo "========================================"
echo " Installation complete!"
echo " You may want to reboot now."
echo "========================================"

