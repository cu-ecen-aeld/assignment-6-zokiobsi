#!/bin/bash
# Script to build image for qemu.
# Author: Siddhant Jajoo.

#init and update poky sudmodule 
#submodule needs to be commited to be "detected"
git submodule init
git submodule sync
git submodule update

# local.conf won't exist until this step on first execution
#this CDs into build directory for build 
source poky/oe-init-build-env

CONFLINE="MACHINE = \"qemuarm64\""

cat conf/local.conf | grep "${CONFLINE}" > /dev/null # check local.conf is configured correctly 
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then # sets up local.conf for you for build target
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi


bitbake-layers show-layers | grep "meta-aesd" > /dev/null #check build layer 
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-aesd layer" # add build layer for you 
	bitbake-layers add-layer ../meta-aesd
else
	echo "meta-aesd layer already exists"
fi

set -e
bitbake core-image-aesd #start the image build 
