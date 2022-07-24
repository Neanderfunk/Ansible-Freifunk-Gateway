#!/bin/bash

# manual batmanupdate / change syntax

# Ist batctl überhaupt auf dem System? Ansonsten gleich wieder raus
batadvequal=-1
if [[ -x "/usr/sbin/batctl" ]] ; then
  batadvequal=2
  bat_adv_v=$(batctl -v|cut -d" " -f4|tr -d "]")
  bat_ctl_v=$(batctl -v|cut -d" " -f2)
  if [ "$bat_adv_v" == "$bat_ctl_v" ] ; then
    batadvequal=1
   fi
  if [ "$bat_ctl_v" == "2017.4" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2018.0" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2018.1" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2018.2" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2018.3" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2018.4" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2018.5" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2019.0" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2019.1" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2019.2" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2019.3" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2020.0" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2019.4" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2019.5" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2020.0" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2020.1" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2020.2" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2020.3" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2020.4" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2020.5" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2021.0" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2021.1" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2021.2" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2021.3" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2021.4" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2021.5" ] ; then
    batadvequal=2
   fi
  if [ "$bat_ctl_v" == "2022.0" ] ; then
    batadvequal=2
   fi
 fi

if [ "$batadvequal" == "2" ] ; then
  # compile batctl
  batversion="2022.1"
  cd /tmp && rm -rf batctl-$batversion
  wget -4 https://downloads.open-mesh.org/batman/stable/sources/batctl/batctl-$batversion.tar.gz
  tar -xf batctl-$batversion.tar.gz
  cd batctl-$batversion &&  make &&  make install && cp /usr/local/sbin/batctl /usr/sbin/batctl
  cd /tmp && rm -rf batctl-$batversion
  rm batctl-$batversion.tar.gz

  #compile batman-adv
  cd /tmp && rm -rf batman-adv-$batversion
  wget -4 https://downloads.open-mesh.org/batman/stable/sources/batman-adv/batman-adv-$batversion.tar.gz
  tar -xf batman-adv-$batversion.tar.gz
  # Den Fehler  "ssl error.....bss_file": Ignorieren, würde nur für UEFI-Secureboot benötigt.
  cd batman-adv-$batversion &&  make && make install
  update-initramfs -u &&  echo . >/var/run/reboot-required
  cd /tmp && rm -rf batman-adv-$batversion
  rm batman-adv-$batversion.tar.gz
  cd /var/cache
  rm -rf /var/cache/apt/

 fi

cd /etc/
find . -type f -print0 | xargs -0 sed -i 's/batctl -m/batctl meshif/g'
cd  /usr/lib/check_mk_agent/local
find . -type f -print0 | xargs -0 sed -i 's/batctl -m/batctl meshif/g'
