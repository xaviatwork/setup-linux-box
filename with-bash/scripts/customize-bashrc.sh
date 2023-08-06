#!/usr/bin/env bash

echo "Remove Support linuxlite banner"
sed -i '/www.linuxliteos.com/d' ~/.bashrc
