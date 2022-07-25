#!/bin/bash
batversion="2022.1"
#export  batversion="2022.1"
cd /usr/src
wget -4 https://downloads.open-mesh.org/batman/stable/sources/batman-adv/batman-adv-$batversion.tar.gz
tar -xf batman-adv-$batversion.tar.gz
rm batman-adv-$batversion.tar.gz
cd batman-adv-$batversion
cat > dkms.conf << EOL
PACKAGE_NAME='batman-adv'
PACKAGE_VERSION="$batversion"
BUILT_MODULE_NAME[0]="batman-adv"
BUILT_MODULE_LOCATION="net/batman-adv"
DEST_MODULE_LOCATION="/extra"
AUTOINSTALL=yes
MAKE="'make'"
CLEAN="'make' clean"
AUTOINSTALL="yes"

EOL
cd ..
dkms add -m batman-adv -v $batversion
dkms build -m batman-adv -v $batversion
dkms install -m batman-adv -v $batversion --force
