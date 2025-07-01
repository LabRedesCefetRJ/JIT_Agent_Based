#! /bin/bash
FRAMEWORK="/usr/bin/jasonEmbedded"
SIMULIDE="/opt/group.chon/simulide/simulide"
SERIALPORT="/dev/ttyEmulatedPort0"
clear
if [[ ! -f "$FRAMEWORK"  ]] || [[ ! -f "$SIMULIDE" ]] || [[ ! -e "$SERIALPORT" ]]
then
    echo "Installing dependencies..."
    sudo clear
    echo "deb [trusted=yes] http://packages.chon.group/ chonos main" | sudo tee /etc/apt/sources.list.d/chonos.list
    sudo apt update
    sudo apt install linux-headers-`uname -r` -y
    sudo apt install jason-embedded chonos-serial-port-emulator chonos-simulide -y
else
    echo "The computer has JaCaMo-CLI and SimulIDE"
fi

/opt/group.chon/simulide/simulide robotBody/robotBody.sim1 &

clear
MSG="Executing the MAS in 10 seconds (Start the simulation)"
sleep 2; clear; echo -n $MSG".."; sleep 2; clear; echo -n $MSG"...."; sleep 2; clear; echo -n $MSG"......"; sleep 2; clear; echo  $MSG"........."

jason proofMyBodyMyPercepts/proofMyBodyMyPercepts.mas2j
