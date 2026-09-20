sudo apt update && sudo apt upgrade && sudo apt full-upgrade -y
sudo apt-get install --no-install-recommends xserver-xorg -y
sudo apt-get install --no-install-recommends xinit -y
sudo apt install lightdm -y
sudo apt install raspberrypi-ui-mods -y  
sudo apt install chromium-browser -y

sudo apt-get install unzip -y
sudo apt-get install cmake -y
sudo wget https://www.waveshare.net/w/upload/0/03/Waveshare35a.zip
sudo unzip ./Waveshare35a.zip
sudo cp waveshare35a.dtbo /boot/overlays/

sudo sed -i 's/Enable DRM VC4 V3D driver/# Enable DRM VC4 V3D driver/g' /boot/firmware/config.txt
sudo sed -i 's/dtoverlay=vc4-kms-v3d/# dtoverlay=vc4-kms-v3d/g' /boot/firmware/config.txt
sudo sed -i 's/max_framebuffers=2/# max_framebuffers=2/g' /boot/firmware/config.txt

sudo tee /boot/firmware/config.txt << 'EOF'
dtparam=spi=on
dtoverlay=waveshare35a
hdmi_force_hotplug=1
max_usb_current=1
hdmi_group=2
hdmi_mode=87
hdmi_cvt 640 480 60 6 0 0 0
hdmi_drive=2
display_rotate=0
EOF

sudo tee ~/.bash_profile << 'EOF'
export FRAMEBUFFER=/dev/fb1
startx 2> /tmp/xorg_errors
EOF

sudo tee /usr/share/X11/xorg.conf.d/99-fbturbo.~ << 'EOF'
Section "Device"
        Identifier      "Allwinner A10/A13 FBDEV"
        Driver          "fbturbo"
        Option          "fbdev" "/dev/fb0"

        Option          "SwapbuffersWait" "true"
EndSection
EOF

sudo raspi-config nonint do_boot_behaviour B2
sudo raspi-config nonint do_wayland W1
sudo reboot
