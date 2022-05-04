#!/usr/bin/env bash

ERR_UNZIP_REQUIRED=101
ERR_GLIBC_REQUIRED=102
ERR_LESS_REQUIRED=103
ERR_AWSCLI_REQUIRED=104
ERR_PYTHON3_REQUIRED=105

function _check_awscli_requirements {
  # unzip glibc, less, groff
  
  if [ "$(unzip -v 1>/dev/null 2>&1)" != 0 ]; then
    echo "[ ERR ] Unzip is required to install AWS CLI"
    exit $ERR_UNZIP_REQUIRED
  fi

  if [ "$(ldd --version 1>/dev/null 2>&1)" != 0 ]; then
    echo "[ ERR ] GLIBC is required by AWS CLI"
    exit $ERR_GLIBC_REQUIRED
  fi

  if [ "$(less --version 1>/dev/null 2>&1)" != 0 ]; then
    echo "[ ERR ] LESS is required by AWS CLI"
    exit $ERR_LESS_REQUIRED
  fi

  echo "[ OK ] AWS CLI installation requirements checked"
}

function _is_aws_installed {
  if [ "$(aws --version 1>/dev/null 2>&1)" != 0 ]; then
    echo "no"
  else
    echo "yes"
  fi
}

function install_aws_cli {
  # https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
  forceInstall=$1
  _check_awscli_requirements

  if [[ -z $forceInstall ]]; then
    awscliInstalled=$(_is_aws_installed)
  else
    if [[ -f "cache/awscliv2.zip" ]]; then
      echo "[ INFO ] Removing awscliv2.zip ..."
      rm cache/awscliv2.zip
    fi
  fi

  if [[ $awscliInstalled != "yes" ]]; then
    echo "[ INFO ] Installing AWS"
    if [[ -f "cache/awscliv2.zip" ]]; then
      echo "[ WARN ] awscliv2.zip already present"
    else
      echo "[ INFO ] Downloadinng awscliv2.zip ..."
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "cache/awscliv2.zip"
    fi

    echo "[ INFO ] Unzipping awscliv2.zip ..."
    local tempFolder="temp/awscli"
    mkdir -p $tempFolder
    unzip cache/awscliv2.zip -d $tempFolder
    echo "[ INFO ] Installing AWS CLI ..."
    sudo $tempFolder/aws/install --update
    echo "[ INFO ] Cleaning unzipped files ..."
    rm -rf $tempFolder

  else
    echo "[ INFO ] AWS already installed"
    echo "         Use 'install_awscli force' to force installation"
    aws --version
  fi
}

function install_aws_session_manager_plugin {
  # https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-debian
  awscliInstalled=$(_is_aws_installed)

  if [[ $awscliInstalled == "yes" ]]; then
    echo "[ OK ] AWS CLI installed"
    aws --version

    if [[ -f "cache/session-manager-plugin.deb" ]]; then
      echo "[ WARN ] Session Manager package already present"
      session-manager-plugin
    else
      echo "[ INFO ] Downloading Session Manager plugin ..."
      curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "cache/session-manager-plugin.deb"
    fi
    sudo dpkg -i cache/session-manager-plugin.deb
  else
    echo "[ ERROR ] AWS CLI is required for AWS Session Manager plugin"
    exit $ERR_AWSCLI_REQUIRED
  fi
}

function _is_python3_installed {
  pythonMajorVersion=$(python --version | awk '{print $2}' | awk -F '.' '{print $1}')
  if [[ $pythonMajorVersion -ge 3 ]]; then
    echo "yes"
  else
    echo "no"
  fi
}

function _is_pip_installed {
  if [ "$(pip --version 1>/dev/null 2>&1)" != 0 ]; then
    echo "no"
  else
    echo "yes"
  fi
}

function install_aws_git_remote_codecommit {
  # https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-git-remote-codecommit.html
  pythonInstalled=$(_is_python3_installed)
  pipInstalled=$(_is_pip_installed)

  if [[ $pythonInstalled == "yes" ]]; then
    if [[ $pipInstalled == "yes" ]]; then
      echo "[ WARN ] PIP already installed"
      pip --version
    else
      echo "[ INFO ] Installing PIP ..."
      sudo apt-get install python3-pip -y
    fi
  else
    echo "[ ERROR ] Python3 or greater is requied"
    exit $ERR_PYTHON3_REQUIRED
  fi

  echo "[ INFO ] Installing Git Remore CodeCommit ..."
  pip install git-remote-codecommit

  # PIP complains when installed in $HOME/.local/bin
  if [[ "$(grep -i -q PATH="$HOME"/.local/bin ~/.profile)" == 0 ]]; then
    echo "[ INFO ] $HOME/.local/bin is already in the PATH"
    echo "         Ignore the PIP warning and start a new terminal session"
  else
    echo "[ WARN ] Add $HOME/.local/bin to \$PATH ..."
    echo "         See https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path"
  fi
}

# Pass a non empty argument to install_cli to reinstall
# Example "install_awscli force" or "install_awscli always"
install_aws_cli ""
install_aws_session_manager_plugin
install_aws_git_remote_codecommit
