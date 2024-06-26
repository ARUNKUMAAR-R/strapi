#!/bin/bash
sudo apt update
curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
bash -E nodesource_setup.sh
sudo apt install nodejs -y
npm install -g yarn
echo -e "skip\n" | npx create-strapi-app simple-strapi --quickstart

