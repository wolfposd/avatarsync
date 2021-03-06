#!/bin/bash

# Script created by Wolf Posdorfer for AvatarSync


# ====     USAGE    ====
# to execute the script call in terminal:
# sh fallback.sh

# ====   SETTINGS   ====

buildtoolspath="/Volumes/HDD/wolf/git/avatarsync/AvatarSync_build_tools/"


# ==== SETTINGS END ====

echo "copying newest application"
cd $buildtoolspath

path=$(java FindPath AvatarSync)
rm -rf AvatarSync/Applications/AvatarSync.app
cp -r "$path" "AvatarSync/Applications/"

cp ./control AvatarSync/DEBIAN/control

echo "signing application"
/opt/theos/bin/ldid -S AvatarSync/Applications/AvatarSync.app/AvatarSync 



echo "removing .DS_Store"
find ./ -name ".DS_Store" | xargs rm


echo "packaging..."
dpkg-deb -Zgzip -b AvatarSync

cp AvatarSync.deb /Volumes/HDD/wolf/git/wolfposd.github.io/

cd /Volumes/HDD/wolf/git/wolfposd.github.io/
sh import.sh



#scppath="/var/www/_repo_priv"
#sshpath="www/_repo_priv/"
#echo "Uploading to {$1}"
#scp AvatarSync.deb ${1}:$scppath
#ssh ${1} "cd $sshpath; sudo sh import.sh; exit;"
