#!/bin/bash

CONTINUE=true;
UNINSTALL=false; #Used to uninstall on cleanup if installation failed to avoid half-installed state 

#Disabling checking of certificate since fresh ubuntu install doesnt seem to validate valid verisign certs 
echo "Downloading latest official nexus package..."
wget --no-check-certificate -O /tmp/nexus.tar.gz "https://install.bankid.com/FileDownloader?fileId=Linux"

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
  CONTINUE=false;
else 
  echo "Extraction completed"	
fi

if $CONTINUE ; then
  echo "Installing nexus"
  cd BISP-*
  sudo ./install* i
  if [ $? -ne 0 ]; then
    echo "ERROR: Operation failed. Installation incomplete."
    CONTINUE=false;
  fi
fi

if $CONTINUE && [ `getconf LONG_BIT` = "64" ]; then
  echo "Detected 64-bit installation - installing additional packages"

  UBUNTU_VERSION=$(lsb_release -d -s |  awk '{print $2}')

  if [[ $UBUNTU_VERSION == 12.04* ]] || [[ $UBUNTU_VERSION == 12.10* ]] || [[ $UBUNTU_VERSION == 13.04* ]]; then
  	echo "Ubuntu $UBUNTU_VERSION detected, running customized installation"
    sudo apt-get install -y nspluginwrapper libstdc++6:i386 libidn11:i386
    if [ $? -ne 0 ]; then
      echo "ERROR: Operation failed. Installation incomplete."
      CONTINUE=false;
      UNINSTALL=true;
    else
    	echo "Additional packages installed"
    fi
    if $CONTINUE ; then
      echo "Installing plugin wrapper..."
      sudo nspluginwrapper -i /usr/local/lib/personal/libplugins.so
      if [ $? -ne 0 ]; then
        echo "ERROR: Operation failed. Installation incomplete."
        UNINSTALL=true;
      else
        echo "Plugin wrapper successfully installed"
      fi
    fi
  fi
  if [[ $UBUNTU_VERSION == 13.10* ]] || [[ $UBUNTU_VERSION == 14.04* ]] ; then
  	echo "Ubuntu $UBUNTU_VERSION detected, running customized installation"
    sudo apt-get install -y nspluginwrapper pcscd:i386 pkcs11-data:i386 libstdc++6:i386 libidn11:i386
    if [ $? -ne 0 ]; then
      echo "ERROR: Operation failed. Installation incomplete."
      CONTINUE=false;
      UNINSTALL=true;
    else
    	echo "Additional packages installed"
    fi
    if $CONTINUE ; then
      echo "Installing plugin wrapper..."
      sudo nspluginwrapper -i /usr/local/lib/personal/libplugins.so
      if [ $? -ne 0 ]; then
        echo "ERROR: Operation failed. Installation incomplete."
        UNINSTALL = true;
      else
        echo "Plugin wrapper successfully installed"
      fi
    fi
  fi


fi

if $UNINSTALL ; then
  echo "Uninstalling nexus since 64-bit wrapper installation failed"
  cd /tmp/BISP*
  sudo ./install* u
fi

echo "Cleaning up"
rm -rf /tmp/BISP*
rm -f /tmp/nexus.tar.gz
