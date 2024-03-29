#!/bin/bash
# Made by Romain Sickenberg with 💚🌍
# Source: https://pimylifeup.com/raspberry-pi-kiosk/

# Disable display power management system from kicking in and blanking out the screen.
# Basically, these three commands set the current xsession not to blank out the screensaver and then disables the screensaver altogether. The third line disables the entire “display power management system” meaning that the desktop interface should never blank out the screen.
xhost +local:
export DISPLAY=:0

xset -display :0 s noblank
xset -display :0 s 0
xset -display :0 -dpms

# Turn off HDMI port // Use -p instead to turn on.
sudo /opt/vc/bin/tvservice -o
echo '1-1' |sudo tee /sys/bus/usb/drivers/usb/unbind
# echo '1-1' |sudo tee /sys/bus/usb/drivers/usb/bind for turn on usb ports.

# Set brightness to half (NEED rpi-backlight).
sudo rpi-backlight -b 50

# Remove mouse from the Display if idle for longer than 0.5 seconds even if root.
unclutter -idle 0.5 -root &

# Sed used to search inside Chromium preferences to toggle some config.
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/pi/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/pi/.config/chromium/Default/Preferences

# Launch Chromium
/usr/bin/chromium-browser --noerrdialogs --disable-infobars --kiosk https://dashboard.smappee.net/ &

while true; do
	# Nothing, just keep the process alive
	sleep 1
done
