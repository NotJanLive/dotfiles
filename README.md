# Installation instructions for arch
1. Boot into the installation menu with a bootable USB built from rufus
2. Connect the device to the internet using the following commands:
   - `iwctl`
   - `station wlan0 scan`
   - `station wlan0 connect <name>`
   - `iwctl`

3. Update GPG-Keys using `pacman-key --init` and `pacman-key --populate` **(optional)**
4. Install archlinux on the device using `archinstall`
   - Profile: `minimal`
   - Audio: Choose `pipewire`
   - Additional packages: `git nano`
   - Repositories: `multilib`
   - Network configuration: `NetworkManager`

5. After installation and reboot, connect the device to the internet again using:
   - `nmcli device wifi connect <name> --ask`
  
6. Installing yay:
   - `cd /opt/`
   - `sudo git clone https://aur.archlinux.org/yay-git.git`
   - `sudo chown -R <user>:<user> yay-git/`
   - `cd yay-git/`
   - `makepkg -si`
   *Update yay using `yay -Syu`*

7. Install hyprland:
   - `cd /opt`
   - `sudo git clone https://github.com/soldoestech/hyprland.git`
   - `sudo chown -R <user>:<user> hyprland/`
   - `cd hyprland/`
   - `chmod +x set-hypr`
   - `./set-hypr`
  
8. Install important packages for this repo:
   - alacritty
   - nautilus
   - hyprlock
   - hyprpaper
   - hypridle
   - atuin
   - dunst
   - neofetch
   - rofi
   - starship
   - waybar
   - swaync
   - zsh
  
9. Download this repo and unzip it

**Further configurations can be made as you wish**
   
