#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then
    exec sudo "$0" "$@"
    echo "Error: failed to execute sudo" >&2
    exit 1
fi

audio_device=$(lspci -vvv | grep "Audio" | awk -F' +' '{print $1}')
echo "Sound device identifier: \"$audio_device\""

hardware_device=$(ls /sys/bus/pci/devices/ | grep "$audio_device")
echo "Hardware device identifier: \"$hardware_device\""

echo 1 > /sys/bus/pci/devices/"$hardware_device"/remove
echo "Marked audio device \"$hardware_device\" as removed"

echo "Rescanning devices"
echo 1 > /sys/bus/pci/rescan
echo "Done."
