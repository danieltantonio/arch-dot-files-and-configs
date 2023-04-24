# Arch Linux Surface Laptop 3 dotfiles And Configs

## Pre-Requisites
If you are installing Arch Linux with an older installation medium (like me) then you will run into a PGP Signature error when running the given command during section `2.2 Install essential packages`. Please update to the latest key-ring to prevent this:

```sh
$ pacman -Sy
$ pacman -S archlinux-keyring
```

Once done you can continue with the installation process.

## How To Use

### Installation
If you already have installed Arch Linux and just want to have a GUI up and running, then feel free to skip this section and go to Post-Installation.

If you are trying to install Arch Linux, please follow the installation guide until after you complete section `3.2 Chroot`.
Once chrooted into the system, download git and a text editor program *ex:* `vi` or `nano`. Personally, I prefer `neovim`.

```sh
$ pacman -S git neovim --noconfirm`
```

`--noconfirm` is just a way to skip the prompt asking if you're sure you want to download.

After downloading git and a text editor, clone this repository and open the directory:

```sh
$ git clone https://github.com/danieltantonio/arch-dot-files-and-configs.git
$ cd arch-dot-files-and-configs
```

Before running `install.sh`, **MAKE SURE** to edit the necessary fields within the shell script. 

```sh
$ nvim install.sh
```

## Credits
All `dotfiles` are a fork from Chris Titus's Hyprland-Titus repo with my own personal edits. If you like this one, you should check out his!
https://github.com/ChrisTitusTech/hyprland-titus
