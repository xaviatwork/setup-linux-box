#!/usr/bin/env bash
set -e

TRUE=0
FALSE=-1
ERR_FILE_NOT_FOUND=1
ERR_EMPTY_REQUIRED_VARS=2

SCRIPTPATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"

function loadDefaults {
  # Checks if the proxy.defaults file exists in the current folder

  if [ -f "$SCRIPTPATH/proxy.defaults" ]; then
    printf '[ INFO ] Loading defaults from: %s ...\n\n' "$SCRIPTPATH/proxy.defaults"
    source "$SCRIPTPATH/proxy.defaults"
  else
    printf '[ ERROR ] No default file found: %s\n\n' "$SCRIPTPATH/proxy.defaults"
    exit $ERR_FILE_NOT_FOUND
  fi
}

# request_sensitive "Prompt text" "defaultValue" -s|--sensitive
# With -s|--sensitive, pass the `-s` option to `read` so there is
# no echo on the terminal (useful for passwords, etc)

function parse_request_args {
  PARAMS=()

  while (("$#")); do
    case "$1" in
    -s | --sensitive)
      SENSITIVE="yes"
      shift
      ;;
    -* | --*=) # Unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # Preserve positional arguments
      PARAMS+=("$1")
      shift
      ;;
    esac
  done

  # Set positional arguments in their proper place
  eval set -- "$PARAMS"
}

function request {
  parse_request_args "$@"

  msg="${PARAMS[0]}"

  if [ "${#PARAMS[@]}" -lt 2 ]; then
    msg+=" (No default value)"
  else
    defaultValue="${PARAMS[1]}"
    msg+=" (default: ${defaultValue})"
  fi

  if [ "${SENSITIVE}" == "yes" ]; then
    read -r -s -p "$msg : " userinput
  else
    read -r -p "$msg : " userinput
  fi

  if [ -z "${userinput}" ]; then
    userinput="$defaultValue"
  fi

  echo "${userinput}"
}

function IsDefined {
  # Returns $TRUE if the variable is defined

  if [ -z "$1" ]; then
    echo "$FALSE"
  else
    echo "$TRUE"
  fi
}

function checkRequiredVars {

  if [ "$(IsDefined "$proxyProtocol")" -eq "$FALSE" ] || [ "$(IsDefined "$proxyURL")" -eq "$FALSE" ] || [ "$(IsDefined "$proxyPort")" -eq "$FALSE" ]; then
    printf "\n[ ERROR ] proxyProtocol, proxyURL and proxyPort are required to configure the proxy\n"
    exit "$ERR_EMPTY_REQUIRED_VARS"
  fi
}

function requestValues {
  # Requests values (shows the defaults loaded from the defaults file)
  proxyProtocol=$(request "Proxy protocol [http or https]" "$proxyProtocol")
  proxyURL=$(request "Proxy URL" "$proxyURL")
  proxyPort=$(request "Proxy Port" "$proxyPort")
  no_proxy=$(request "Do not use proxy for:" "$no_proxy")

  requiresAuthentication=$(request "Proxy requires authentication" "$requiresAuthentication")
  if [ "$requiresAuthentication" == 'true' ]; then
    proxyUsername=$(request "Proxy username" "$proxyUsername")
    proxyPassword=$(request "Proxy password [will not be shown]" "$proxyPassword" -s)
    proxyPassword=$(echo -n "$proxyPassword" | base64)
  fi
}

function createProxyVarsFile {

  rm "$HOME/proxy.vars" && touch "$HOME/proxy.vars"
  {
    printf "PROXY_PROTOCOL=%s\n" "$proxyProtocol"
    printf "PROXY_URL=%s\n" "$proxyURL"
    printf "PROXY_PORT=%s\n" "$proxyPort"
    printf "PROXY_NO_PROXY=%s\n" "$no_proxy"
    printf "PROXY_AUTHENTICATION=%s\n" "$requiresAuthentication"
    printf "PROXY_USERNAME=%s\n" "$proxyUsername"
    printf "PROXY_PASSWORD=%s\n" "$proxyPassword"
  } >>"$HOME/proxy.vars"
  printf "\n\n[ INFO ] Contents of %s:\n\n" "$HOME/proxy.vars"
  cat "$HOME/proxy.vars"
}

function copyProxyConfFile {
  cp "$SCRIPTPATH/proxy.conf" "$HOME/proxy.conf"
}

function updateProfileFile {

  # Include it to $HOME/.profile if it is not already present
  # https://stackoverflow.com/questions/3557037/appending-a-line-to-a-file-only-if-it-does-not-already-exist
  grep -qxF "source \"${HOME}/proxy.conf\"" "${HOME}/.profile" || echo "source \"${HOME}/proxy.conf\"" >>"${HOME}/.profile"

}

# --------------------------------------
# ------ SCRIPT STARTS HERE ------------
# --------------------------------------

loadDefaults

requestValues

createProxyVarsFile

copyProxyConfFile

updateProfileFile
