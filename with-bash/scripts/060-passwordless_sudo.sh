#! /bin/bash

sudo grep -qxF "$USER ALL=(ALL) NOPASSWD:ALL" /etc/sudoers || echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo

if [[ $? -eq 0 ]]; then
  echo "Passwordless sudo configured!"
else
  echo "Something went wrong"
fi
