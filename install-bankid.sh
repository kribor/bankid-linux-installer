#!/bin/sh


wget -O /tmp/nexus.tar.gz "https://install.bankid.com/Download?defaultFileId=Linux"
cd /tmp	
tar xzf nexus.tar.gz
cd BISP-*
sudo ./install* i

MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  sudo apt-get install -y nspluginwrapper libstdc++6:i386 libidn11:i386
  sudo nspluginwrapper -i /usr/local/lib/personal/libplugins.so
fi

rm -rf /tmp/BISP*
rm -f /tmp/nexus.tar.gz
