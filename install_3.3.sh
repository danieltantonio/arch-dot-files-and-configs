###################################################################################################
##############  Installation Automation Script for Arch Linux On Microsoft Surface 3  #############
###################################################################################################
# AUTHOR: DANIEL T. ANTONIO
# DATE: 10/04/2022
# OBJECTIVE: To automate the Arch Linux Installation and Post-Installation process for a
# Microsoft Windows Surface 3 Laptop and get it up and running to a GUI Window Manager Environment
# DESCRIPTION: Read the Arch Linux Installation Wiki for context/more details.
# wiki url: https://wiki.archlinux.org/title/Installation_guide/
#
# I made this because:
# 1. Setting up Arch Linux for the first time can be intimidating for the novice user.
# 2. Setting up Arch Linux over & over again on a Microsoft Surface is annoying.
# 3. If I want to re-install Arch Linux again in the future, I can get my system up and running
# quickly rather than being stuck on the install screen for a good 10-20 minutes.
#
# After running `arch-chroot /mnt` (section 3.2) edit the following variables in this file and run
# this script.
#
# The Optional part of this script is exactly that... Optional. You can either delete it, comment 
# or modify it. Up to you :)
#
###########################!!!DO NOT EDIT THE $LINE VARIABLE (Ln.21)!!!############################
# IF YOU SO CHOOSE TO REMOVE THE COMMENT LINE WITHIN /etc/locale.gen MANUALLY, THEN FEEL FREE TO  #
# REMOVE THE $LINE VARIABLE (Ln.21) AND REMOVE Ln.38						  #
###################################################################################################


### BEGIN VARIABLES ###
REGION='America'
CITY='Los_Angeles'
LANG='en_US.UTF-8'
USERNAME='Daniel'
HOSTNAME='Surface'
EFI_PARTITION='nvme0n1p1'

###!!! DO NOT CHANGE BELOW VARIABLE(s) !!!###
LINE=$(grep -n $LANG /etc/locale.gen | cut -d: -f1)
###!!! DO NOT CHANGE ABOVE VARIABLE(s) !!!###

### END VARIABLES ###


###########################
#   Installation Set Up   #
###########################

# Refresh Pacman repository and metadata and update necessary packages
pacman -Syy

# Install latest Arch Linux KeyRing to avoid PGP errors
pacman -S archlinux-keyring --noconfirm

# Install git
pacman -S git --noconfirm

# Refresh and update all packages
pacman -Syyu --noconfirm

# Packages needed to finish Arch Linux Installation
pacman -S man sudo grub efibootmgr dosfstools os-prober mtools networkmanager --noconfirm

##  Setting the Time Zone (3.3)  ##
ln -sf /usr/share/zoneinfo/$REGION/$CITY/etc/localtime
hwclock --systohc

##  Set Localization (3.4)  ##
# Get line of $LANG and remove comment indicator from /etc/locale.gen then create and set locale
sed -i $LINE's/^.//' /etc/locale.gen
echo LANG=$LANG > /etc/locale.conf
locale-gen

##  Network Configuration (3.5)  ##
echo $HOSTNAME > /etc/hostname
echo '127.0.0.1		localhost' > /etc/hosts
echo '::1		localhost' >> /etc/hosts
echo '127.0.1.1		'$HOSTNAME >> /etc/hosts

##  Boot Loader (3.8)  ##

# Have EFI notice GRUB Bootloader and configure GRUB
mkdir /boot/EFI
mount /dev/$EFI_PARTITION /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --efi-directory=/boot/EFI --recheck
grub-mkconfig -o /boot/grub/grub.cfg


################################
#   Post Installation Set Up   #
################################

# Install SDDM Login-Manager for Wayland
pacman -S sddm --noconfirm

# Create new user with user home directory at /home/$USERNAME
useradd -m $USERNAME

## Edit /etc/sudoers to allow the %wheel group to have sudo permissions so we can make Admin user.
# Find which line the wheel group with no password is on and remove the comment indicator
sed -i $(grep -n '%wheel ALL(ALL:ALL) = NOPASSWD: ALL' /etc/sudoers | cut -d: -f1)'s/^.//' \
	/etc/sudoers

# Append $USERNAME to wheel group
usermod -aG wheel $USERNAME

# Set Passwords
clear
echo [ EDIT PASSWORD FOR \(\'root\'\) USER ]
passwd

clear
echo [ EDIT PASSWORD FOR \(\'$USERNAME\'\) USER ]
passwd $USERNAME


#######################################
# OPTIONAL FEEL FREE TO DELETE/MODIFY #
#######################################

## Install packages ##
# NeoVim: Customizable Text Editor
# NeoFetch: Displays computer specs in terminal. Makes you look very 1337.
# gcc: Compiler for the C Programming language.
# kiTTY: Terminal emulator.
# Nautilus: GUI File Manager

pacman -S neovim neofetch gcc kitty nautilus firefox openssh --noconfirm

##  Microsoft Surface Setup  ##

# Import keys Linux-Surface uses to sign packages.
curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
	| pacman-key --add -

# Locally sign the fingerprint
pacman-key --finger 56C464BAAC421453
pacman-key --lsign-key 56C464BAAC421453

# Add respository to Pacman
echo '[linux-surface]' >> /etc/pacman.conf
echo 'Server = https://pkg.surfacelinux.com/arch' >> /etc/pacman.conf

# Refresh pacman repository metadata then install Linux-Surface kernel and it's dependencies.
pacman -Syyu
pacman -S linux-surface linux-surface-headers iptsd --noconfirm

# !!OPTIONAL!! Additional Wifi Firmware for: Surface Pro 4, 5, & 6, Book 1 & 2, Laptop 1 & 2
#pacman -S linux-firmware-marvell

# Secureboot Key. Will sign the Linux-Surface kernel into the bootloader.
# Has to be installed on it's own since it comes with instructions
pacman -S linux-surface-secureboot-mok --noconfirm

# Configure GRUB to use Linux-Surface kernel
grub-mkconfig -o /boot/grub/grub.cfg


#############
#   Reset   #
#############
echo '##################################################################################################'
echo 'Almost done! Here are a few more things you must do real quick on your own (I suggest'
echo 'writing this down somewhere if this is your first time installing Arch Linux or any Linux system):'
echo '##################################################################################################'
echo ''
echo '1. Logout of chroot environment. And unmount Filesystem partition.'
echo ''
echo 'logout'
echo 'unmount -l /mnt'
echo ''
echo '2. Restart the system and load into your newly installed Linux Operating System. Not the Installer/Live System.'
echo ''
echo '3. Log into the root user and follow the instructions under "FINAL (After-Reboot): Services To'
echo 'Start/Enable, at the bottom of this script.'
echo ''
echo 'cat install.sh'
echo ''


######################################################
#   FINAL (After-Reboot): Services To Start/Enable   #
######################################################
## Use systemctl to tell systemd to enable installed services
## `$` represents the commands you should be running within the terminal

## Enable NetworkManager
# $ systemctl enable NetworkManager

## Enable sddm Login Manager
# $ systemctl enable sddm

## Reboot system
# $ reboot

########################
#   You're all done.   #
########################
# You are all set! Just log out of the root user and log back into your own user.
# Feel free to reach out to me if you need help with anything. Happy hacking :)

