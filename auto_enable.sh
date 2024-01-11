#!/bin/bash

sudo mount -n -o remount,rw /

# sudo apt install kexec-tools kdump-tools -y

sudo dpkg -i *.deb

if [ -f "/usr/local/driver/fw_tool/fw_setenv" ];
then
    sudo bash -c 'echo 0 > /sys/block/mmcblk0boot0/force_ro'
    sudo /usr/local/driver/fw_tool/fw_setenv vidargs 'video=imxdpufb5:off video=imxdpufb6:off video=imxdpufb7:off crashkernel=256M'
    sudo bash -c 'echo 1 > /sys/block/mmcblk0boot0/force_ro'
fi

sudo cp kexe-monitor.service /lib/systemd/system/
sudo systemctl enable kexe-monitor.service

sudo sync

sudo reboot