#!/bin/bash
board_folder=$1
echo $board_folder
su
source /etc/profile
# check whether aocl is valid
if [ !`aocl version | grep Intel` ]
then
    echo "aocl not installed."
    exit
fi
# copy folder
cp -r $board_folder "$INTELFPGAOCLSDKROOT/board/"
cd $INTELFPGAOCLSDKROOT/board/$board_folder
# ！！！！here is very easy to happen problem
source ./setup_f10a_pr.sh
# config environment
echo "export AOCL_BOARD_PACKAGE_ROOT=$INTELFPGAOCLSDKROOT/board/$board_folder" >> /etc/profile
echo "export LD_LIBRARY_PATH=$AOCL_BOARD_PACKAGE_ROOT/linux64/lib:$LD_LIBRARY_PATH" >> /etc/profile
source /etc/profile
aocl install
aocl diagnose
if [ !`aocl diagnose | grep DIAGNOSTIC_PASSED` ]
then
    echo "some problem happens, install failed."
    exit
fi
echo "${board_folder} has been installed successfully."
