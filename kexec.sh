#!/bin/bash

kexec -p --command-line="root=/dev/mmcblk0p2 ro rootwait console=ttyLP3 reset_devices systemd.unit=kdump-tools-dump.service nr_cpus=1" /home/sr/kexec-Image.gz