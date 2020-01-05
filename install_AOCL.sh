#!/bin/bash
# check whether root
if [ `whoami` = "root" ];then
    # install perl version 5 or later
    
else
	echo "非root用户！"
    exit
fi
