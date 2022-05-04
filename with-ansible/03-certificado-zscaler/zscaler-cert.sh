#!/usr/bin/env bash

#!/usr/bin/env bash
set -e

ERR_FILE_NOT_FOUND=1

SCRIPTPATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"

ZscalerCertPath="root-certificate-zscaler"
ZscalerCertFileName="zscaler-root-certificate.crt"
userLocalCert="/usr/local/share/ca-certificates"

function checkZscalerCert {

  if [ ! -f "$SCRIPTPATH/$ZscalerCertPath/$ZscalerCertFileName" ]; then
    printf '\n[ ERROR ] Zscaler certificate not found at %s' "$SCRIPTPATH/$ZscalerCertPath/$ZscalerCertFileName\n"
    exit $ERR_FILE_NOT_FOUND
  fi
}

function copyCert {

  printf '\n[ INFO ] Copying Zscaler certificate to %s ...\n' "$userLocalCert"
  sudo cp "$SCRIPTPATH/$ZscalerCertPath/$ZscalerCertFileName" "$userLocalCert"
}

function updateCerts {
  sudo update-ca-certificates
}

function validateCert {
  printf '\n[ INFO ] Certificate installed as %s : \n' "$userLocalCert/$ZscalerCertFileName"
  sudo openssl x509 -text -in $userLocalCert/$ZscalerCertFileName | head
  printf "\n...\n"
}

# --------------------------------------
# ------ SCRIPT STARTS HERE ------------
# --------------------------------------

checkZscalerCert

copyCert

updateCerts

validateCert
