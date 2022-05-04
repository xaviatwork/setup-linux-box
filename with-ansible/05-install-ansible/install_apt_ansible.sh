#!/usr/bin/env bash

set -e

printf "\n[ INFO ] Update APT cache ...\n"
sudo apt update
printf "\n[ INFO ] Install dependencies ...\n"
sudo apt install software-properties-common --yes
printf "\n[ INFO ] Add PPA for Ansible...\n"
printf "IMPORTANT: run sudo with -E or --preserve-env\n"
printf "           to keep https_proxy environment variables\n"
sudo --preserve-env add-apt-repository --update ppa:ansible/ansible --yes
sudo apt install ansible --yes
printf "\n[ INFO ] Validation...\n"
ansible --version
