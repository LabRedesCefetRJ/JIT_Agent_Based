#! /bin/bash
FRAMEWORK="/usr/bin/jasonEmbedded"
SIMULIDE="/opt/group.chon/simulide/simulide"
SERIALPORT="/dev/ttyEmulatedPort0"
MIDDLEWARE="/usr/bin/velluscinum"
clear
if [[ ! -f "$FRAMEWORK"  ]] || [[ ! -f "$SIMULIDE" ]] || [[ ! -e "$SERIALPORT" ]] || [[ ! -e "$MIDDLEWARE" ]]
then
    echo "Installing dependencies..."
    sudo clear
    echo "deb [trusted=yes] http://packages.chon.group/ chonos main" | sudo tee /etc/apt/sources.list.d/chonos.list
    sudo apt update
    sudo apt install linux-headers-`uname -r` -y
    sudo apt install jason-cli velluscinum-cli chonos-serial-port-emulator chonos-simulide -y
else
    echo "The computer has Jason, Velluscinum and SimulIDE"
fi

chonos-simulide RFID/RFID.sim1  &

clear
MSG="Executing the MAS in 10 seconds (Start the simulation)"
sleep 2; clear; echo -n $MSG".."; sleep 2; clear; echo -n $MSG"...."; sleep 2; clear; echo -n $MSG"......"; sleep 2; clear; echo  $MSG"........."

jason MAS/raulMercado.mas2j
