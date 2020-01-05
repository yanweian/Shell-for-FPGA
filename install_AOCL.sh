#!/bin/bash
echo "start install AOCL environment."
# check whether root
if [ `whoami` != "root" ]
then
    echo "need root！"
    exit
fi
# check centos version
now_version=`rpm -q centos-release|cut -d- -f3`
limit="7"
if [ $now_version \< $limit ]
then
    echo "the version of centos need greater or equal to 7!"
    exit
fi
if [ $now_version == "8.0" ]
then
    now_version="8"
fi
# install perl version 5 or later,gcc,gcc-c++
yum install perl gcc gcc-c++ wget -y
# install linux os kernel source and headers
# get kernel version
kernel_version=`uname -r`
echo ${kernel_version}

# get kernel headers file
if [ ! -f "kernel-headers-${kernel_version}.rpm" ]; then
  wget "http://mirror.centos.org/centos/${now_version}/BaseOS/x86_64/os/Packages/kernel-headers-${kernel_version}.rpm"
fi
if [ ! -f "kernel-devel-${kernel_version}.rpm" ]; then
  wget "http://mirror.centos.org/centos/${now_version}/BaseOS/x86_64/os/Packages/kernel-devel-${kernel_version}.rpm"
fi
# install kernel headers
rpm -ivh "kernel-headers-${kernel_version}.rpm"
rpm -ivh "kernel-devel-${kernel_version}.rpm"
echo "prerequisite has been installed successfully."

AOCL_file=`ls | grep AOCL-pro-*-linux.tar`
# install AOCL
# check whether AOCL install file exist
if [ !$AOCL_file ]; then
    echo "no AOCL install file."
    exit
fi
# unzip file
tar xvf $AOCL_file
bash ./setup_pro.sh
echo $INTELFPGAOCLSDKROOT
echo "export PATH=$INTELFPGAOCLSDKROOT/bin:$PATH" >> /etc/profile
echo "export LD_LIBRARY_PATH=$INTELFPGAOCLSDKROOT/host/linux64/lib:$LD_LIBRARY_PATH" >> /etc/profile
echo "export LM_LICENSE_FILE=$LM_LICENSE_FILE:/root/intelFPGA_pro/license.dat" >> /etc/profile
source /etc/profile
aocl version
echo "install success."