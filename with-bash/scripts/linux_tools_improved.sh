#!/usr/bin/env bash
# Install modern replacement of linux basic tools
# https://dev.to/heraldofsolace/replace-your-existing-unix-utilities-with-these-modern-alternatives-2bfo

source aux_scripts/get_latest_version_from_github

function _check_for_dotlocalbin {
  if [[ -d "$HOME/.local/bin" ]]; then
    printf '[ WARN ] Folder %s already exists' "$HOME/.local/bin"

  else
    printf '[ INFO ] Creating folder %s ...' "$HOME/.local/bin"
    mkdir -p "$HOME"/.local/bin
  fi
}

function _remove_from_dotlocalbin {
  local app="$1"
  if [[ -f "${HOME}/.local/bin/${app}" ]]; then
    echo "[ WARN ] Removing : ${HOME}/.local/bin/${app} ..."
    rm "${HOME}"/.local/bin/"${app}"
  fi
}

function install_bat {
  # bat https://github.com/sharkdp/bat
  #
  # In Ubuntu, the app is renamed to "batcat" to avoid conflict with other application
  # From the repo's README:
  # Important: If you install bat this way, please note that the executable may be installed as batcat
  #            instead of bat (due to a name clash with another package). You can set up a bat -> batcat
  #            symlink or alias to prevent any issues that may come up because of this and to be
  #            consistent with other distributions:
  sudo apt install bat -y

  _check_for_dotlocalbin
  printf '[ INFO ] Creating link for bat in %s ...' "$HOME/.local/bin"
  ln -s /usr/bin/batcat ~/.local/bin/bat
}

function remove_bat {
  sudo apt remove bat -y
  sudo apt autoremove -y
  if [[ -L "${HOME}/.local/bin/bat" ]]; then
    echo "[ WARN ] Removing symbolkink link: ${HOME}/.local/bin/bat ..."
    rm "${HOME}/.local/bin/bat"
  fi
}

function install_procs {
  # ps replacement
  # --------------
  # https://github.com/dalance/procs
  local gh_account_project
  gh_account_project="dalance/procs"
  local latestVersion
  latestVersion="$(get_latest_version_from_github $gh_account_project)"

  if [[ -f "cache/procs-${latestVersion}-x86_64-lnx.zip" ]]; then
    echo "[ WARN ] Latest version of the package ${latestVersion} is in the cache"
  else
    echo "[ INFO ] Downloading version ${latestVersion} from GitHub ..."
    curl -LJ "https://github.com/${gh_account_project}/releases/download/${latestVersion}/procs-${latestVersion}-x86_64-lnx.zip" -o cache/procs-"${latestVersion}"-x86_64-lnx.zip
  fi
  mkdir -p temp/procs
  unzip -o cache/procs-"${latestVersion}"-x86_64-lnx.zip -d temp/procs
  echo "[ INFO ] Installing procs in ${HOME}/.local/bin"
  _check_for_dotlocalbin
  mv temp/procs/procs "${HOME}"/.local/bin
  echo "[ INFO ] Cleaning temp files ..."
  rm -rf temp/procs
}

function remove_procs {
  _remove_from_dotlocalbin "procs"
}

function install_exa {
  # ls
  # https://github.com/ogham/exa
  local gh_account_project="ogham/exa"
  local latestVersion
  latestVersion="$(get_latest_version_from_github $gh_account_project)"
  if [[ -f "cache/exa-linux-${latestVersion}.zip" ]]; then
    echo "[ WARN ] Latest version of the package ${latestVersion} is in the cache"
  else
    echo "[ INFO ] Downloading version ${latestVersion} from GitHub ..."
    curl -LJ "https://github.com/${gh_account_project}/releases/download/${latestVersion}/exa-linux-x86_64-${latestVersion}.zip" -o cache/exa-linux-"${latestVersion}".zip
  fi
  mkdir -p temp/exa
  unzip -o cache/exa-linux-"${latestVersion}".zip -d temp/exa
  echo "[ INFO ] Installing exa in ${HOME}/.local/bin"
  _check_for_dotlocalbin
  mv temp/exa/bin/exa "${HOME}"/.local/bin
  echo "[ INFO ] Cleaning temp files ..."
  rm -rf temp/exa
}

function remove_exa {
  _remove_from_dotlocalbin "exa"
}

# cat, improved
install_bat
# remove_bat

# ls, improved
# install_exa
# remove_exa

# ps, improved
# install_procs
# remove_procs
