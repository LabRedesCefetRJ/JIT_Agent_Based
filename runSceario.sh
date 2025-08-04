#! /bin/bash
FRAMEWORK="/usr/bin/jason"
SIMULIDE="/opt/group.chon/simulide/simulide"
SERIALPORT="/dev/ttyEmulatedPort0"
XTERM="/usr/bin/xterm"
VELLUSCINUM="/usr/bin/velluscinum"

clear
if [[ ! -f "$FRAMEWORK"  ]] || [[ ! -f "$SIMULIDE" ]] || [[ ! -e "$SERIALPORT" ]] || [[ ! -e "$XTERM" ]] || [[ ! -e "$VELLUSCINUM" ]]
then
    echo "Installing dependencies..."
    sudo clear
    echo "deb [trusted=yes] http://packages.chon.group/ chonos main" | sudo tee /etc/apt/sources.list.d/chonos.list
    sudo apt update
    sudo apt install linux-headers-`uname -r` -y
    sudo apt install jason-cli chonos-serial-port-emulator chonos-simulide xterm velluscinum-cli -y
    clear
else
    echo "The computer has Jason, SimulIDE and Velluscinum"
fi


BigChainDBServer="http://testchain.chon.group:9984"

#see: http://testchain.chon.group:9984/api/v1/transactions/0a73dc0f45cc7b4584d07385c114ff54a78f9d341be798e32c12277b3a287b1b
TOKEN=0a73dc0f45cc7b4584d07385c114ff54a78f9d341be798e32c12277b3a287b1b

FORNECEDORPrivK=8Gj9WTcEWMNmmbE2mdFRakbVotDpPCE3Jsjuz7fE1pDT
FORNECEDORPublK=7mZEAyhV9ZT8JEepk2fPxm4AyMj2sDuVgtqS6CEgSgjy

MERCADOPrivK=2eRFEQRq9vNqdPZi9tKyg115RGvhgyjuah9EgNDWHmp7
MERCADOPubkK=D34qTAJzjau1U6BxcUauKqNiYyLNKTcKNMtUnQBz9rjV

#see: https://github.com/chon-group/Velluscinum/wiki/walletBalance-CLI
FORNECEDORSALDO=`velluscinum walletBalance http://testchain.chon.group:9984 $FORNECEDORPrivK $FORNECEDORPublK | grep $TOKEN | xargs | cut -d " " -f 3`

if [[ -n "$FORNECEDORSALDO" ]]; then
    echo "Transfering $FORNECEDORSALDO agentsCoin to SUPERMERCADO Wallet"
    #see: https://github.com/chon-group/Velluscinum/wiki/transferToken-CLI
    echo "velluscinum transferToken $BigChainDBServer $FORNECEDORPrivK $FORNECEDORPublK $TOKEN $MERCADOPubkK $FORNECEDORSALDO"
fi

echo "Starting Simulation..."
sleep 3

cd fornecedor/
xterm -T "Fornecedor Multi-agent System" -e ./runMAS.sh &

sleep 3
cd ../mercado/
xterm -T "Mercado Multi-agent System" -e ./runMAS.sh &