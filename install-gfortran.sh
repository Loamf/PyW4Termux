#!/data/data/com.termux/files/usr/bin/bash

# Color Codes
red="\e[0;31m"          # Red
green="\e[0;32m"        # Green
cyan="\e[0;36m"         # Cyan
white="\e[0;37m"        # White
nocol="\033[0m"         # Default

# script from setup-pointless-repo.sh (https://github.com/its-pointless/gcc_termux/blob/master/setup-pointless-repo.sh) + green ECHOs & slient by Loamf
#######################################################################################################################
# Get some needed tools. coreutils for mkdir command, gnugp for the signing key, and apt-transport-https to actually connect to the repo

echo -e "${green}Updating installed packages...${nocol}"
apt-get update < /dev/null > /dev/null
apt-get --assume-yes upgrade < /dev/null > /dev/null
echo -e "${green}Installing some necessary packages for pointless-repo...${nocol}"
apt-get --assume-yes install coreutils gnupg wget < /dev/null > /dev/null
# Make the sources.list.d directory
mkdir -p $PREFIX/etc/apt/sources.list.d
# Write the needed source file
echo -e "${green}Installing pointless-repo...${nocol}"
if apt-cache policy | grep -q "termux.*24\|termux.org\|bintray.*24" ; then
echo "deb https://its-pointless.github.io/files/24 termux extras" > $PREFIX/etc/apt/sources.list.d/pointless.list
else
echo "deb https://its-pointless.github.io/files/21 termux extras" > $PREFIX/etc/apt/sources.list.d/pointless.list
fi
# Add signing key from https://its-pointless.github.io/pointless.gpg
if [ -n $(command -v curl) ]; then
curl -sL https://its-pointless.github.io/pointless.gpg | apt-key add -
elif [ -n $(command -v wget) ]; then
wget -qO - https://its-pointless.github.io/pointless.gpg | apt-key add -
fi
# Update apt
apt-get update < /dev/null > /dev/null
#######################################################################################################################

# check and set LD_LIBRARY_PATH if needed
if [ ! "$LD_LIBRARY_PATH" == "/data/data/com.termux/files/usr/lib" ]; then
  echo "export LD_LIBRARY_PATH=$PREFIX/lib" >> ~/.bashrc
  source ~/.bashrc
  echo -e "${nocol}LD_LIBRARY_PATH ${cyan}is set to ${nocol}${LD_LIBRARY_PATH}${nocol}"
else
  echo -e "${nocol}LD_LIBRARY_PATH ${green} found (from termux lib folder) - ${nocol}(${LD_LIBRARY_PATH})${nocol}"
fi

# installing gfortran and lfortran library
apt --assume-yes install libgfortran5 lfortran gcc-8

# enabling gfortran if user wants to
echo "Enable GFortran?"
read -p "Do you want to continue [Y/n] " -r CONFIRM
echo
if [[ $CONFIRM =~ ^[Yy] ]]; then
  bash termux-setupclang-gfort-8
else
  echo "Abort. You can still enable it using \" bash termux-setupclang-gfort-8 \""
fi

# tells the user to restart the termux app or type command
echo -e "${green}GFortran have been installed, restart termux using"
echo -e "${nocol}\" exit \"${nocol}"
echo -e "${cyan}or${nocol}"
echo -e "${cyan}use ${nocol}\" source ~/.bashrc \"${cyan} to update ${nocol}LD_LIBRARY_PATH${nocol}"
exit
