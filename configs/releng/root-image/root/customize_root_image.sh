#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# usermod -s /usr/bin/bash root
# cp -aT /etc/skel/ /root/

# check if user exists
user=$(grep guest /etc/passwd | cut -f1 -d :)
if [ "$user" = "" ]; then
	useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/bash guest
	sed -i 's|# autologin=.*|autologin=guest|' /etc/lxdm/lxdm.conf
	sed -i 's|# session=/usr/bin/startlxde|session=/usr/bin/enlightenment_start|' /etc/lxdm/lxdm.conf
	sed -i 's|# %wheel .*|%wheel ALL=(ALL) NOPASSWD: ALL|' /etc/sudoers
fi

 #chmod 750 /etc/sudoers.d
 #chmod 440 /etc/sudoers.d/g_wheel

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf


systemctl enable pacman-init.service choose-mirror.service lxdm.service
