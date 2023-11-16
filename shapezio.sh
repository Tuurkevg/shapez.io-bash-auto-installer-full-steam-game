#!/bin/bash

# Definieer tekstkleuren
RED='\033[0;31m'
NC='\033[0m' # No Color


sudo apt update
# Geef een rode tekst weer met echo
echo -e "${RED}Installing unzip, ffmpeg and Java${NC}"
sudo apt install git unzip ffmpeg default-jdk -y

echo -e "${RED}Installing Node.js 16${NC}"
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings

if [ ! -e /etc/apt/keyrings/nodesource.gpg ]; then
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
fi
NODE_MAJOR=16
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update
sudo apt-get install nodejs -y
# Navigeer naar de gewenste map, bijv. /home/$USER/Documents
cd "/home/$USER/Documents"

echo -e "${RED}Downloading shapez.io source code${NC}"
git clone https://github.com/tobspr-games/shapez.io.git
#echo -e "${RED}Unzipping shapez.io source code${NC}"
# unzip shapez.io-master
#rm master.zip
sudo chmod +7 shapez.io/*
cd "shapez.io"
echo -e "${RED}installing yarn${NC}"
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn

echo -e "${RED}Compiling shapez.io source code${NC}"
sudo yarn

cd "/home/$USER/Documents/shapez.io/electron"
sudo yarn --ignore-optional
yarn --ignore-optional

cd "/home/$USER/Documents/shapez.io/gulp"
yarn
yarn gulp &
echo -e "${RED}Do not close this terminal!! the game will stop within 60s en restart after a time!!!${NC}"
sleep 60
echo -e "${RED}Do not close this terminal!! the game will stop within 60s en restart after a time!!!${NC}"
pkill -f "gulp"
yarn gulp build.standalone-steam
sudo yarn gulp standalone.standalone-steam.prepare
sudo yarn gulp standalone.standalone-steam.package.linux64

echo -e "${RED}shapez.io Steam version is installed in /home/$USER/Documents/shapez.io/build_output/standalone-steam/shapez-linux-x64/play.sh${NC}"
cd /home/$USER/Documents/shapez.io/build_output/standalone-steam/shapez-linux-x64/
./play.sh
