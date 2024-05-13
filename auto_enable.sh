#!/bin/bash

src800_name="SRC800"
src880_name="SRC880"
src3000_name="SRC3000"
src600_name="SRC600"

if [ $(cat /etc/srcname) == "$src800_name" ]; then
    sudo cp sysctl.conf /etc/
    sudo cp kexe-monitor-imx8qxp.service /lib/systemd/system/kexe-monitor.service
    # kdump-tools用来第二内核启动后dump文件用的，要不然就卡住不动
    sudo chmod a+x kdump-tools-default kdump-tools-init
    sudo cp kdump-tools-init /etc/init.d/kdump-tools
    sudo cp kdump-tools-default /etc/default/kdump-tools
    sync
    sudo mount -n -o remount,rw /
    sudo umount /dev/mmcblk0p3
fi

# sudo apt install kexec-tools kdump-tools -y

sudo dpkg -i *.deb

if [ -f "/usr/local/driver/fw_tool/fw_setenv" ];
then
    sudo bash -c 'echo 0 > /sys/block/mmcblk0boot0/force_ro'
    if [ $(cat /etc/srcname) == "$src800_name" ]; then
        sudo /usr/local/driver/fw_tool/fw_setenv vidargs 'video=imxdpufb5:off video=imxdpufb6:off video=imxdpufb7:off crashkernel=256M'
        sudo cp kexe-monitor-imx8qxp.service /lib/systemd/system/kexe-monitor.service
    elif [ $(cat /etc/srcname) == "$src3000_name" ]; then
        sudo /usr/local/driver/fw_tool/fw_setenv defargs 'pci=nomsi crashkernel=600M'    
        sudo cp kexe-monitor-imx8qm.service /lib/systemd/system/kexe-monitor.service
    fi
    sudo bash -c 'echo 1 > /sys/block/mmcblk0boot0/force_ro'
fi

sudo cp kexec-Image.gz /home/sr/
sudo cp kexec.sh /home/sr
sudo chmod a+x /home/sr/kexec.sh
sudo cp sysctl.conf /etc/
sudo sysctl -p


sudo systemctl daemon-reload
sudo systemctl enable kexe-monitor.service
sudo systemctl start kexe-monitor.service

sudo sync

sudo reboot