#!/usr/bin/env bash

echo "Removing LibreOffice..."
sudo apt-get remove --purge 'libreoffice*' -y
sudo apt-get clean
sudo apt-get autoremove

echo "Removing Thunderbid..."
sudo apt-get remove --purge 'thunderbird*' -y
sudo apt-get clean
sudo apt-get autoremove

