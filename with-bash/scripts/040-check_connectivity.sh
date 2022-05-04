#!/usr/bin/env bash

testSite="https://www.google.com"

if [ -z "$https_proxy" ]; then
  echo "\$https_proxy is not set"
else
  echo "Checking internet connectivity..."

  response=$(curl -k --write-out '%{http_code}' --silent --head --output /dev/null ${testSite})

  if [ "$response" -lt 400 ]; then
    echo "Online!"
  else
    echo "O F F L I N E - N O T   C O N N E C T E D   T O   T H E   I N T E R N E T"
  fi
fi
