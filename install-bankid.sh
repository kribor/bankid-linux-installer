#!/bin/sh

CONTINUE = true;
UNINSTALL = false; #Used to uninstall on cleanup if installation failed to avoid half-installed state 

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
  CONTINUE = false;
else 
  echo "Extraction completed"	
fi

if [ CONTINUE ]
  echo "Installing nexus"
  cd BISP-*
  sudo ./install* i
  if [ $? -ne 0 ]; then
    echo "ERROR: Operation failed. Installation incomplete."
    CONTINUE = false;
  fi
fi

if [ CONTINUE && `getconf LONG_BIT` = "64" ]; then
  echo "Detected 64-bit installation - installing additional packages"
  sudo apt-get install -y nspluginwrapper libstdc++6:i386 libidn11:i386
  if [ $? -ne 0 ]; then
    echo "ERROR: Operation failed. Installation incomplete."
    CONTINUE = false;
    UNINSTALL = true;
  else
  	echo "Additional packages installed"
  fi
  if [ CONTINUE ]
    echo "Installing plugin wrapper..."
    sudo nspluginwrapper -i /usr/local/lib/personal/libplugins.so
    if [ $? -ne 0 ]; then
      echo "ERROR: Operation failed. Installation incomplete."
      UNINSTALL = true;
    else
      echo "Plugin wrapper successfully installed"
    fi
fi

if [ UNINSTALL ]
  echo "Uninstalling nexus since 64-bit wrapper installation failed"
  cd /tmp/BISP*
  sudo ./install* u
fi

echo "Cleaning up"
rm -rf /tmp/BISP*
rm -f /tmp/nexus.tar.gz
