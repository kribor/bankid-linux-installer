#!/bin/sh

#Disabling checking of certificate since fresh ubuntu install doesnt seem to validate valid verisign certs 
echo "Downloading latest official nexus package..."
wget --no-check-certificate -O /tmp/nexus.tar.gz "https://install.bankid.com/Download?defaultFileId=Linux"
if [ $? -ne 0 ]; then
  echo "ERROR: Operation failed. Installation incomplete."
  exit 1
fi

echo "Download Complete"

echo "Extracting nexus..."
cd /tmp	
tar xzf nexus.tar.gz
if [ $? -ne 0 ]; then
  echo "ERROR: Operation failed. Installation incomplete."
  exit 1
fi
echo "Extraction completed"

echo "Installing nexus"
cd BISP-*
sudo ./install* i
if [ $? -ne 0 ]; then
  echo "ERROR: Operation failed. Installation incomplete."
  exit 1
fi

if [ `getconf LONG_BIT` = "64" ]; then
  echo "Detected 64-bit installation - installing additional packages"
  sudo apt-get install -y nspluginwrapper libstdc++6:i386 libidn11:i386
  if [ $? -ne 0 ]; then
    echo "ERROR: Operation failed. Installation incomplete."
    exit 1
  fi
  echo "Additional packages installed"
  echo "Installing plugin wrapper..."
  sudo nspluginwrapper -i /usr/local/lib/personal/libplugins.so
  if [ $? -ne 0 ]; then
    echo "ERROR: Operation failed. Installation incomplete."
    exit 1
  fi
  echo "Plugin wrapper successfully installed"
fi

rm -rf /tmp/BISP*
rm -f /tmp/nexus.tar.gz
