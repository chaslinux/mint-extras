#!/bin/bash

# Script started by Charles McColm, cr@theworkingcentre.org
# for The Working Centre's Computer Recycling Project
# Installs a bunch of extra software that's useful for
# Linux Mint XFCE or Cinnamon 22.2 deployments

# Special thanks to Cecylia Bocovich for assistance with automating parts of the script
# https://github.com/cohosh

# Also thanks to https://prxk.net for the wallpaper he created in blender based on the
# existing CR logo

# Just run as ./mint-extras.sh, DO NOT run as sudo ./mint-extras.sh

### Add some colour to the script ###
WHITE='\033[1;37m'
NC='\033[0m'
LTGREEN='\033[1;32m'
PURPLE='\033[1;35m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[1;36m'

### Define some variables ###
currentdir=$(pwd) # set the current directory
envdesk=$(echo $OSFAMILY $XDG_CURRENT_DESKTOP) # Determine what the current desktop environment is and assign it to envdesk
GIMPLANG=$(locale | grep LANG | head -1 | cut -c 6- | cut -c -2)
OS=$(lsb_release -a | grep Distributor | cut -c 17-)
LOCALE=$(echo $LANG | cut -c -5)
distro=$(cat /etc/linuxmint/info | grep CODENAME | cut -c 10-)

### Copy a link to some Linux Mint videos to the desktop
cp $currentdir/Linux_Mint-Getting_Started.desktop /home/$USER/Desktop/.

### Change the sources to the University of Waterloo if the Locale is Canadian ###
if [[ "$distro" == "zena" ]]
    then
        if [[ "$LOCALE" == "en_CA" ]]
            then
            echo -e "${WHITE}*** ${PURPLE}This is Canada, so setting Univeristy of Waterloo to be local mirror. ${WHITE}***${NC}"
            sudo cp $currentdir/zena-official-package-repositories.list /etc/apt/sources.list.d/official-package-repositories.list
        fi
elif [[ "$distro" == "zara" ]]
    then
        if [[ "$LOCALE" == "en_CA" ]]
            then
            echo -e "${WHITE}*** ${PURPLE}This is Canada, so setting Univeristy of Waterloo to be local mirror. ${WHITE}***${NC}"
            sudo cp $currentdir/zara-official-package-repositories.list /etc/apt/sources.list.d/official-package-repositories.list
        fi
fi

### Run updates first ###
sudo apt update
sudo apt upgrade -y

### Extra Apt Software ###
sudo apt install gnome-contacts -y
sudo apt install gparted -y
sudo apt install gnome-firmware -y
sudo apt install btop mc curl git build-essential acpi unzip -y
sudo apt install webp-pixbuf-loader -y # Install webp support
sudo DEBIAN_FRONTEND=noninteractive apt install steam ttf-mscorefonts-installer -y
sudo apt install guvcview cheese -y
sudo apt install vlc -y
echo "Installing msttcorefonts"
sudo DEBIAN_FRONTEND=noninteractive apt install msttcorefonts -y
echo "Installing gstreamer1.0-plugins-ugly"
sudo apt install gstreamer1.0-plugins-ugly -y
sudo apt install gstreamer1.0-plugins-bad* -y
echo "Installing libdvd-pkg"
sudo DEBIAN_FRONTEND=noninteractive apt install libdvd-pkg -y
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure libdvd-pkg
sudo apt install inkscape -y
echo "Installing Krita"
sudo apt install krita -y
echo "Installing a bunch of games"
sudo apt install lbreakout2 frozen-bubble kobodeluxe aisleriot gnome-mahjongg icebreaker supertux pingus -y
echo "Installing audacity"
sudo apt install audacity -y
sudo apt install cpu-x -y
sudo apt install gnome-disk-utility -y
sudo apt install hfsprogs hfsplus hfsutils -y # install tools to read MacOS formatted drives
echo "Installing GIMP..."
sudo apt install gimp gimp-help-$GIMPLANG -y
sudo apt install klavaro -y

### Extra Flatpak Software ###
# Install OnlyOffice & extra programs
flatpak update
flatpak install org.onlyoffice.desktopeditors -y
flatpak install us.zoom.Zoom -y
flatpak install com.github.PintaProject.Pinta -y
flatpak install org.godotengine.GodotSharp -y
flatpak install io.sourceforge.pysolfc.PySolFC -y
flatpak install net.nokyan.Resources -y

### check if this appears to be a laptop and if so install tlp and powertop ###
if [ -d "/proc/acpi/button/lid" ]; then
	sudo apt install tlp powertop-1.13 -y
	sudo service enable tlp
fi

### Remove uvcdynctrl as it seems to sometimes create enormous (200GB+) log files ###
sudo apt purge uvcdynctrl -y
sudo apt autoremove -y

### Make a wallpaper directory ~/Pictures/Wallpaper and copy CR background to it ###
### then set it as the wallpaper ###
mkdir ~/Pictures/Wallpaper
cp *.jpg ~/Pictures/Wallpaper/.


if [ "$envdesk" == "XFCE" ];
    then
        ### The following changes are to make Linux Mint XFCE a bit more friendly. Other XFCE-based distributions
        ### have these settings on, oddly Linux Mint XFCE doesn't.
        xfconf-query -c thunar-volman -p /autoplay-video-cds/command -s 'vlc dvd://'
        # Show volume adjustment when pressing volume keys
        xfconf-query -c xfce4-panel -p /plugins/plugin-12/show-notifications -r
        xfconf-query -c xfce4-panel -p /plugins/plugin-12/show-notifications -s true

        # Change the power button pressed action to ASK whether the person wants to power down (was do nothing)
        # xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/power-button-action --create --type int --set 3
        cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/power-button-action --set 3

        # Show the default set of icons for the home folder, filesystem, removable drives and trash
        # also show tooltips for desktop icons
        xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-home --set true
        xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-removable --set true
        xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash --set true
        xfconf-query -c xfce4-desktop -p /desktop-icons/show-tooltips --set true

        xfconf-query -c xfce4-desktop -p $(xfconf-query -c xfce4-desktop -l | grep "workspace0/last-image") -s ~/Pictures/Wallpaper/CRbackground.jpg
        xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/image-path --set /home/$USER/Pictures/Wallpaper
fi

if [ "$envdesk" == "X-Cinnamon" ];
    then
        if [ ! -d "/home/$USER/.config/cinnamon/backgrounds/" ]; then
            mkdir -p /home/$USER/.config/cinnamon/backgrounds/
        fi
        echo "/home/$USER/Pictures/Wallpaper" >> /home/$USER/.config/cinnamon/backgrounds/user-folders.lst
        gsettings set org.cinnamon.desktop.background picture-uri "file:///home/$USER/Pictures/Wallpaper/CRbackground.jpg"
fi

# Set Linux Mint to update automatically
sudo mintupdate-automation upgrade enable

