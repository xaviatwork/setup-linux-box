#!/usr/bin/env bash

set -e

ERR_FILE_NOT_FOUND=1

SCRIPTPATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"

aptConfLocation="/etc/apt/apt.conf.d"

function checkProxyVarsFile {

  if [ ! -f "$HOME/proxy.vars" ]; then
    printf "\n[ ERROR ] File %s not found!\n" "$HOME/proxy.vars"
    exit "$ERR_FILE_NOT_FOUND"
  else
    printf "\n[ INFO ] Using values from %s ...\n" "$HOME/proxy.vars"
    cat "$HOME/proxy.vars"
    source "$HOME/proxy.vars"
  fi
}

function setAPTProxy {
  touch "$SCRIPTPATH/apt_proxy.conf"

  printf "# Proxy configuration for APT\n" >>"$SCRIPTPATH/apt_proxy.conf"

  if [ "$PROXY_AUTHENTICATION" == 'true' ]; then
    PROXY_PASSWORD=$(echo -n "$PROXY_PASSWORD" | base64 -d)
    {
      printf 'Acquire::http::proxy \"%s://%s:%s@%s:%s\";\n' "$PROXY_PROTOCOL" "$PROXY_USERNAME" "$PROXY_PASSWORD" "$PROXY_URL" "$PROXY_PORT"
      printf 'Acquire::https::proxy \"%s://%s:%s@%s:%s\";\n' "$PROXY_PROTOCOL" "$PROXY_USERNAME" "$PROXY_PASSWORD" "$PROXY_URL" "$PROXY_PORT"
    } >>"$SCRIPTPATH/apt_proxy.conf"
  else
    {
      printf 'Acquire::http::proxy \"%s://%s:%s\";\n' "$PROXY_PROTOCOL" "$PROXY_URL" "$PROXY_PORT"
      printf 'Acquire::https::proxy \"%s://%s:%s\";\n' "$PROXY_PROTOCOL" "$PROXY_URL" "$PROXY_PORT"
    } >>"$SCRIPTPATH/apt_proxy.conf"
  fi

  if [ -f "$aptConfLocation/apt_proxy.conf" ]; then
    sudo rm "$aptConfLocation/apt_proxy.conf" && sudo mv "$SCRIPTPATH/apt_proxy.conf" "$aptConfLocation/apt_proxy.conf"
  else
    sudo mv "$SCRIPTPATH/apt_proxy.conf" "$aptConfLocation/apt_proxy.conf"
  fi

  printf "\n[ INFO ] Configuration done! \n"
  cat "$aptConfLocation/apt_proxy.conf"
}

function validateProxyConfiguration {
  sudo apt update
}

# --------------------------------------
# ------ SCRIPT STARTS HERE ------------
# --------------------------------------

checkProxyVarsFile

setAPTProxy

validateProxyConfiguration
