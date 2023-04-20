### DO NOT BE ROOT WHILE RUNNING THIS SCRIPT ###

# Make sure we are in user home directory
cd ~

# Install yay AUR package helper
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Install GUI, helpers, applications, and fonts
# Taken from ChrisTitus :)
yay -S hyprland-git polkit-gnome ffmpeg neovim viewnior rofi    \
pavucontrol thunar starship wl-clipboard wf-recorder swaybg     \
grimblast-git ffmpegthumbnailer tumbler playerctl               \
noise-suppression-for-voice thunar-archive-plugin kitty         \
waybar-hyprland-git wlogout swaylock-effects sddm-git pamixer   \
nwg-look-bin nordic-theme papirus-icon-theme dunst otf-sora     \
ttf-nerd-fonts-symbols-common otf-firamono-nerd inter-font      \
ttf-fantasque-nerd noto-fonts noto-fonts-emoji ttf-comfortaa    \
ttf-jetbrains-mono-nerd ttf-icomoon-feather ttf-iosevka-nerd    \
adobe-source-code-pro-fonts brave-bin

# Enable services
systemctl enable NetworkManager
systemctl enable sddm