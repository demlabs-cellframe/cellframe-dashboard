#!/bin/bash

set -e

if [ ${0:0:1} = "/" ]; then
    HERE=`dirname $0`
else
    CMD=`pwd`/$0
    HERE=`dirname ${CMD}`
fi

#this script has been stolen from dockerfile of https://github.com/sickcodes/Docker-OSX
#it does some magic with kvm
#and lauches qemu with catalina image and ssh access to it

#add a mountpoint inside MacOSX
export EXTRA="-virtfs local,path=${PWD},mount_tag=hostshare,security_model=passthrough,id=hostshare"

echo "Disk is being copied between layers... Please wait a minute..." 
sudo touch /dev/kvm /dev/snd "${IMAGE_PATH}" "${BOOTDISK}" "${ENV}" 2>/dev/null || true 
sudo chown -R $(id -u):$(id -g) /dev/kvm /dev/snd "${IMAGE_PATH}" "${BOOTDISK}" "${ENV}" 2>/dev/null || true 


sed -i '/^.*InstallMedia.*/d' Launch.sh && export BOOTDISK="${BOOTDISK:=/home/arch/OSX-KVM/OpenCore/OpenCore-nopicker.qcow2}"     
nohup Xvfb :99 -screen 0 1920x1080x16 & until [[ "$(xrandr --query 2>/dev/null)" ]]; do sleep 1 ; done 
stat "${IMAGE_PATH}" 
echo "Large image is being copied between layers, please wait a minute..." 
/home/arch/OSX-KVM/enable-ssh.sh 

[[ -e ~/.ssh/id_docker_osx ]] || { /usr/bin/ssh-keygen -t rsa -f ~/.ssh/id_docker_osx -q -N "" && chmod 600 ~/.ssh/id_docker_osx; }
 
nohup /bin/bash -c /home/arch/OSX-KVM/Launch.sh &

echo "Booting Docker-OSX in the background. Please wait..."

until [[ "$(sshpass -p${PASSWORD:=alpine} ssh-copy-id -f -i ~/.ssh/id_docker_osx.pub -p 10022 ${USERNAME:=user}@127.0.0.1)" ]]; 
do 
    echo "Disk is being copied between layers. Repeating until able to copy SSH key into OSX..."
    sleep 1
done

#print uname
ssh -i ~/.ssh/id_docker_osx ${USERNAME:=user}@127.0.0.1 -p 10022 uname -a


#have to emulate bash-over-ssh



