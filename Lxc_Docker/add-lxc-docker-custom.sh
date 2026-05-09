#!/bin/bash
CONFIGF=$1
cd $GITHUB_WORKSPACE/kernel_workspace
wget https://github.com/Flyme66/lxc-docker/releases/download/Lxc5.0/lxc-docker-config.txt
aa=$(cat lxc-docker-config.txt)
for i in $aa
do
echo $i >> $CONFIGF
done
