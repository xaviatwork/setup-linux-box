#!/usr/bin/env bash

# Load dependencies
source ./aux_scripts/request_user_input
source ./aux_scripts/request_sensitive_input

defaultProxyURL_PORT="11.22.33.44.:80"

if [ -f local/noproxy.conf ]; then
  printf "[ INFO ] Using no_proxy from temp/noproxy.conf ..."
  source local/noproxy.conf
fi

if [ -z "$NoProxyDomainList" ]; then
  NoProxyDomainList=".local,.internal"
fi
aptConfLocation="/etc/apt/apt.conf.d"

function configure_http_proxy_env_vars {
  proxyURL_PORT="$1"
  if [[ -z "${proxyURL_PORT}" ]]; then
    proxyURL_PORT=$defaultProxyURL_PORT
  fi

  http_proxy="http://${proxyUser}:${proxyPasswd}@${proxyURL_PORT}"

  # Always create a new file
  {
    echo "# ENV vars to configure CLI proxy"
    echo "export http_proxy=http://${proxyUser}:${proxyPasswd}@${proxyURL_PORT}"
    echo "export https_proxy=${http_proxy}"
    echo "export no_proxy=${NoProxyDomainList}"
  } >"${HOME}"/.http_proxy.conf

  # Include it to .bashrc if it is not already present
  # https://stackoverflow.com/questions/3557037/appending-a-line-to-a-file-only-if-it-does-not-already-exist
  grep -qxF "source \"${HOME}/.http_proxy.conf\"" "${HOME}"/.bashrc || echo "source \"${HOME}/.http_proxy.conf\"" >>"${HOME}"/.bashrc

  echo
  echo "[ OK ] Open a new terminal session to load your .bashrc file again"
  echo "       -----------------------------------------------------------"
  cat "${HOME}"/.http_proxy.conf
  echo
}

function configure_apt_proxy {
  proxyURL_PORT="$1"
  if [[ -z "${proxyURL_PORT}" ]]; then
    proxyURL_PORT=$defaultProxyURL_PORT
  fi

  if [[ -f "${aptConfLocation}/proxy.conf" ]]; then
    echo "[ WARN ] File ${aptConfLocation}/proxy.conf already exists"
    echo "[ WARN ] Current file content:"
    echo
    cat "${aptConfLocation}/proxy.conf"
  else

    http_proxy="http://${proxyUser}:${proxyPasswd}@${proxyURL_PORT}"

    # Always create a new file
    echo "# PROXY settings" | sudo tee "${HOME}"/.http_proxy.conf
    echo "Acquire::http::proxy \"${http_proxy}\";" | sudo tee -a "${aptConfLocation}/proxy.conf"
    echo "Acquire::https::proxy \"${http_proxy}\";" | sudo tee -a "${aptConfLocation}/proxy.conf"
  fi
  echo
  echo "[ OK ] Proxy configuration set for APT!"
}

if [ -z "${SET_HTTP_PROXY}" ] || [ -z "${SET_APT_PROXY}" ]; then
  proxyUser=$(request "Enter proxy user" "MY_USERNAME")
  proxyPasswd=$(request_sensitive "Enter proxy password")
fi

if [[ -z ${SET_HTTP_PROXY} ]]; then
  configure_http_proxy_env_vars ""
fi

if [[ -z ${SET_HTTP_PROXY} ]]; then
  configure_apt_proxy ""
fi
