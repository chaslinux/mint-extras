#!/bin/bash
# Script started by Charles McColm, cr@theworkingcentre.org
# for The Working Centre's Computer Recycling Project
# Installs a bunch of extra software that's useful for our
# Linux Mint XFCE 22 (Wilma) deployments
# Special thanks to Cecylia Bocovich for assistance with automating parts of the script
# https://github.com/cohosh
#
# Just run as ./mint-extras.sh, DO NOT run as sudo ./mint-extras.sh


# set the current directory
currentdir=$(pwd)

# Run updates first as some software may not install unless the system is
# updated
sudo apt update && sudo apt upgrade -y

# Mint already has integrated flatpack support

distro=$(cat /etc/lsb-release | grep CODENAME)

# Install OnlyOffice
flatpak install org.onlyoffice.desktopeditors -y

# install Zoom for conferencing
flatpak install us.zoom.Zoom -y

# install Discord for discord conferencing
flatpak install com.discordapp.Discord -y

# install Mission Center because it's a nice way to monitor resources
flatpak install io.missioncenter.MissionCenter -y 

# install gparted, it's surprisingly not in Linux Mint XFCE
sudo apt install gparted -y

# install gnome-firmware, a graphical program to update firmware on 2015 or newer systems with UEFI enabled
sudo apt install gnome-firmware -y

# Control the CPU governor to select between power saving and performance mode
sudo apt install cpupower-gui -y

# install btop, htop, mc, curl, git and build-essential because they're awesome tools
sudo apt install btop htop mc curl git build-essential acpi unzip -y

# Install webp support
sudo apt install webp-pixbuf-loader -y

# Install Steam and some Microsoft Fonts
echo "Installing Steam and MS TTF Fonts"
sudo DEBIAN_FRONTEND=noninteractive apt install steam ttf-mscorefonts-installer -y

# Install FreeCAD Flatpack software
flatpak install org.freecad.FreeCAD -y

# Install PySol Flatpak - Pysol Debian package is bugged because it needs old dependencies
# with Thanks to Tom Goulet for suggesting we include this back in.
flatpak install io.sourceforge.pysolfc.PySolFC -y

# install guvcview and cheese - cheese has issues with some webcams
echo "Installing guvcview"
sudo apt install guvcview cheese -y

# installing VLC
echo "Installing VLC"
sudo apt install vlc -y

# installing msttcorefonts
# 02/06/2022 - added DEBIAN_FRONTEND=noninteractive because I saw a Y/N font prompt on a system I'd stepped away from
echo "Installing msttcorefonts"
sudo DEBIAN_FRONTEND=noninteractive apt install msttcorefonts -y

# Microsoft has gracefully given us some cool opentype fonts, let's install those
# Sadly they're burried in a subdirectory of a subdirectory and not named nicely, so let's do that too
cd $currentdir

if [ ! -e CascadiaCode-2404.23.zip ]
	then
		wget https://github.com/microsoft/cascadia-code/releases/download/v2404.23/CascadiaCode-2404.23.zip
		unzip CascadiaCode-2404.23.zip
		mkdir -p CascadiaCode
		mv $currentdir/ttf/* CascadiaCode
		sudo cp -r CascadiaCode/ /usr/share/fonts/truetype
		rm -rf CascadiaCode/
		rm -rf ttf/
		rm -rf woff2/
		mkdir -p CascadiaCode
		mv $currentdir/otf/static/* CascadiaCode/
		rm -rf otf/
	else
		echo "CascadiaCode already downloaded and unzipped"
fi
sudo cp -r CascadiaCode/ /usr/share/fonts/opentype

# installing gstreamer1.0-plugins-ugly
echo "Installing gstreamer1.0-plugins-ugly"
sudo apt install gstreamer1.0-plugins-ugly -y

# install plugins to allow parole to play movie DVDs
sudo apt install gstreamer1.0-plugins-bad* -y

# installing tuxpaint
echo "Installing tuxpaint"
sudo apt install tuxpaint -y

# installing DVD decryption software
echo "Installing libdvd-pkg"
sudo DEBIAN_FRONTEND=noninteractive apt install libdvd-pkg -y
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure libdvd-pkg

# installing Inkscape
echo "Installing Inkscape"
sudo apt install inkscape -y

# install Krita, as it's handy for artists. Note, this adds lots of KDE dependencies
echo "Installing Krita"
sudo apt install krita -y

# installing handbrake and winff
echo "Installing handbrake and winff"
sudo apt install handbrake winff -y

# installing games
# added icebreaker 10/27/2021
echo "Installing a bunch of games"
sudo apt install lbreakout2 freedroid frozen-bubble kobodeluxe aisleriot gnome-mahjongg icebreaker supertux mrrescue pingus caveexpress -y

# installing hydrogen drum kit and kits
echo "Installing Hydrogen"
sudo apt install hydrogen hydrogen-drumkits -y

# install audacity
echo "Installing audacity"
sudo apt install audacity -y

# removed neofetch, not updated anymore, install fastfetch
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
sudo apt update
sudo apt install fastfetch -y

# install hardinfo cpu-x
sudo apt install hardinfo cpu-x -y

# install Ticket Booth - for oraganizing movies and tv shows you want to watch
sudo apt install ticketbooth -y


# install more screensavers!
sudo apt install xscreensaver xscreensaver-data xscreensaver-data-extra -y
sudo apt install xscreensaver-gl xscreensaver-gl-extra -y
sudo apt install xscreensaver-screensaver-bsod -y

# install putty for terminal SSH hackers
sudo apt install putty -y

# install gnome-disk-utility
sudo apt install gnome-disk-utility -y

# install tools to read MacOS formatted drives
sudo apt install hfsprogs hfsplus hfsutils -y

# set up the sensors
sensors=$(dpkg -s lm-sensors | grep Status)
if [ ! "$sensors" == "Status: install ok installed" ]
	then
		echo "Installing lm-sensors"
		sudo apt install lm-sensors -y
		sudo sensors-detect
		sensors > /home/$USER/Desktop/sensors.txt
	else
		echo "Lm-sensors is already installed."
  		sensors > /home/$USER/Desktop/sensors.txt
fi

# set VLC to be the default DVD player
# xfconf-query -c thunar-volman -p /autoplay-video-cds/command -s 'vlc dvd://'


# check if this appears to be a laptop and if so install tlp and powertop
if [ -d "/proc/acpi/button/lid" ]; then
	sudo apt install tlp powertop-1.13 -y
	sudo service enable tlp
fi

# Remove uvcdynctrl as it seems to sometimes create enormous (200GB+) log files
sudo apt purge uvcdynctrl -y
sudo apt autoremove -y

# GIMP is not installed in Linux Mint, so let's install it
echo "Installing GIMP..."
sudo apt install gimp -y

# Install Godot for making games
sudo apt install godot3 -y

# Install Tuxtyping for kids
sudo apt install tuxtype -y

### The following changes are to make Linux Mint XFCE a bit more friendly. Other XFCE-based distributions
### have these settings on, oddly Linux Mint XFCE doesn't.

# Show volume adjustment when pressing volume keys
xfconf-query -c xfce4-panel -p /plugins/plugin-12/show-notifications -r
xfconf-query -c xfce4-panel -p /plugins/plugin-12/show-notifications -s true

# Change the power button pressed action to ASK whether the person wants to power down (was do nothing)
# xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/power-button-action --create --type int --set 3
cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/power-button-action --set 3

# Show the default set of icons for the home folder, filesystem, removable drives and trash
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-home --set true
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-removable --set true
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash --set true

# Make a wallpaper directory ~/Pictures/Wallpaper and copy CR background to it
# then set it as the wallpaper
mkdir ~/Pictures/Wallpaper
cp CRbackground.png ~/Pictures/Wallpaper/.
xfconf-query -c xfce4-desktop -p $(xfconf-query -c xfce4-desktop -l | grep "workspace0/last-image") -s ~/Pictures/Wallpaper/CRbackground.png


