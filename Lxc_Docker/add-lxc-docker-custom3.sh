#!/bin/bash
CONFIGF=$1
cd $GITHUB_WORKSPACE/kernel_workspace/android-kernel
wget https://raw.githubusercontent.com/makingrom/LXC-DOCKER-KernelSU_Action/refs/heads/main/Lxc_Docker/lxc-docker-config3.txt
aa=$(cat lxc-docker-config3.txt)
for i in $aa
do
echo "当前目录：$(pwd)"
echo $i >> $CONFIGF
done
