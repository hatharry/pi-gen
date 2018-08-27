#!/bin/bash -e

on_chroot << EOF
update-alternatives --install /usr/bin/x-www-browser \
  x-www-browser /usr/bin/chromium-browser 86
update-alternatives --install /usr/bin/gnome-www-browser \
  gnome-www-browser /usr/bin/chromium-browser 86
sudo -u pi mkdir -p /home/pi/.config/openbox
EOF

install -m 644 ./mpv_*_armhf.deb "${ROOTFS_DIR}/tmp/"
install -m 644 ./emby-theater_*_armhf.deb "${ROOTFS_DIR}/tmp/"
install -m 644 ./autostart "${ROOTFS_DIR}/home/pi/.config/openbox"

on_chroot << EOF
chown pi:pi /home/pi/.config/openbox/autostart
apt-get install -y /tmp/mpv_*_armhf.deb
apt-get install -y /tmp/emby-theater_*_armhf.deb
rm /tmp/mpv_*_armhf.deb
rm /tmp/emby-theater_*_armhf.deb
sed -i 's/#disable_overscan/disable_overscan/g' /boot/config.txt
sed -i 's/#autologin-user=/autologin-user=pi/g' /etc/lightdm/lightdm.conf
sed -i 's/#autologin-session=/autologin-session=openbox/g' /etc/lightdm/lightdm.conf
EOF
