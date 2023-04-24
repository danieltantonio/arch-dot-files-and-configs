### DO NOT BE ROOT WHILE RUNNING THIS SCRIPT ###
# Enable NetworkManager and connect to internet first
#
# `$ systemctl enable NetworkManager`
# `$ systemctl start NetworkManager`
#

# Install yay AUR package helper
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Create `home` directories
mkdir ~/Pictures
mkdir ~/Documents
mkdir ~/Videos
mkdir ~/Projects

mkdir ~/Pictures/wallpapers

# Install GUI, drivers, applications, and fonts
# Taken from ChrisTitus :)
sudo ./pack_install/pack_install.sh

# Move wallpaper to wallpapers folder
mv wallhaven-j5rd55.png ~/Pictures/wallpapers

# Move all config files to user home .config directory
cp -r dotconfig/dunst/ ~/.config/
cp -r dotconfig/hypr/ ~/.config/
cp -r dotconfig/kitty/ ~/.config/
cp -r dotconfig/pipewire/ ~/.config/
cp -r dotconfig/rofi/ ~/.config/
cp -r dotconfig/swaylock/ ~/.config/
cp -r dotconfig/waybar/ ~/.config/

# Enable services
systemctl enable sddm

# Reboot
reboot
