#! /bin/bash
FRAMEWORK="/usr/bin/jason"
MIDDLEWARE="/usr/bin/velluscinum"
clear
if [[ ! -f "$FRAMEWORK"  ]] || [[ ! -f "$MIDDLEWARE" ]]
then
    echo "Installing dependencies..."
    sudo clear
    echo "deb [trusted=yes] http://packages.chon.group/ chonos main" | sudo tee /etc/apt/sources.list.d/chonos.list
    sudo apt update
    sudo apt install jason-cli velluscinum-cli -y
else
    echo "The computer has Jason and Velluscinum"
fi

jason raulFornecedor.mas2j
