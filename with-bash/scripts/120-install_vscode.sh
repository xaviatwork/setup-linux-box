#!/user/bin/env bash

function install_vscode {
  sudo apt-get install code 2>/dev/null
  if [ $? -eq "$ERR_UNABLE_TO_LOCATE_PACKAGE" ]; then
    echo "[ WARN ] VSCode repository is not configured"
    echo "         Package code cannot be located."
    echo " ... configuring"
    # https://code.visualstudio.com/docs/setup/linux
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt-get update && sudo apt-get install apt-transport-https code -y
  else
    echo "[ INFO ] VSCode repository configured"
    echo "  ... installing]"
    sudo apt-get update && sudo apt-get install apt-transport-https code -y
  fi
}

install_vscode
