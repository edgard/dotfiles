#!/bin/bash

sed -i 's#^\(GRUB_CMDLINE_LINUX=".*\)"$#\1 ivrs_ioapic[9]=00:14.0 ivrs_ioapic[10]=00:00.1"#' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
