#!/bin/bash
batversion="2024.4"
#export  batversion="2024.4"

## prerequirements (base batman include)
apt-get update
apt-get install -y build-essential pkg-config libnl-3-dev libnl-genl-3-dev
apt-get install -y batctl bridge-utils # klingt unlogisch holt aber ggf noch dependencies
apt-mark hold batctl # damit nicht noch ein älteres batctl nachkommt später.
apt-get install -y dkms
## modul ab dem nächsten reboot automatisch laden
grep -q -c ^batman-adv /etc/modules || printf "\nbatman-adv\n" >>/etc/modules 

## install batctl
cd /tmp && rm -rf batctl-$batversion
wget -4 https://downloads.open-mesh.org/batman/stable/sources/batctl/batctl-$batversion.tar.gz
tar -xf batctl-$batversion.tar.gz
cd batctl-$batversion &&  make &&  make install && cp /usr/local/sbin/batctl /usr/sbin/batctl
cd /tmp && rm -rf batctl-$batversion
rm batctl-$batversion.tar.gz

## preparing dkms-direcctory
cd /usr/src
wget -4 https://downloads.open-mesh.org/batman/stable/sources/batman-adv/batman-adv-$batversion.tar.gz
tar -xf batman-adv-$batversion.tar.gz
rm batman-adv-$batversion.tar.gz
cd batman-adv-$batversion
cat > dkms.conf << EOL
PACKAGE_NAME='batman-adv'
PACKAGE_VERSION="$batversion"
BUILT_MODULE_NAME[0]="batman-adv"
BUILT_MODULE_LOCATION[0]="net/batman-adv/"
DEST_MODULE_LOCATION[0]="/kernel/net/batman-adv/"
PRE_INSTALL=preinstall.sh
AUTOINSTALL=yes
MAKE[0]="make KERNELPATH=\${kernel_source_dir}"
CLEAN="make KERNELPATH=\${kernel_source_dir} clean"

EOL

cat > x509.genkey << EOL
[ req ]
default_bits = 4096
distinguished_name = req_distinguished_name
prompt = no
x509_extensions = myexts

[ req_distinguished_name ]
CN = Modules

[ myexts ]
basicConstraints=critical,CA:FALSE
keyUsage=digitalSignature
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid

EOL

cat > preinstall.sh << EOL
#!/bin/bash
openssl req -new -nodes -utf8 -sha512 -days 36500 -batch -x509 -config x509.genkey -outform DER -out signing_key.x509 -keyout signing_key.pem
find /usr/src/ -path '*-generic/certs' -exec cp signing_key.x509 {}/. \;
find /usr/src/ -path '*-generic/certs' -exec cp signing_key.pem {}/. \;
rm signing_key.x509
rm signing_key.pem

EOL

chmod +x preinstall.sh
cd ..

dkms add -m batman-adv -v $batversion
dkms build -m batman-adv -v $batversion
dkms install -m batman-adv -v $batversion --force
modprobe batman-adv
batctl -v
update-initramfs -u


