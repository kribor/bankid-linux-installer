bankid-linux-installer
======================

Graphical Installation
1. Download installation script: https://github.com/kribor/bankid-linux-installer/archive/master.zip
2. Extract the zip file
3. Right click the file install-bankid.sh, choose properties, switch to the permissions tab and check the "allow executing file as program" box
4. Doubleclick to run and choose execute in terminal
5. Supply your password when asked
6. Clean up by removing the script and zip file

Install in terminal, run:

wget https://raw.github.com/kribor/bankid-linux-installer/master/install-bankid.sh
chmod +x install-bankid.sh
./install-bankid.sh
rm -f install-bankid.sh



Tested OSes
===========
Ubuntu 12.04 Precise Pangolin 32-bit
Ubuntu 12.04 Precise Pangolin 64-bit
Ubuntu 13.10 Saucy Salamander 32-bit
Ubuntu 13.10 Saucy Salamander 64-bit
