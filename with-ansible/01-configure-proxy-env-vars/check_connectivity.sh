#!/usr/bin/env bash

testSite="https://www.google.com"

if [ -z "$https_proxy" ]; then
  printf "\n[ ERROR ] \$https_proxy is not set\n"
else
  printf "\n[ INFO ] Checking internet connectivity...\n"

  response=$(curl -k --write-out '%{http_code}' --silent --head --output /dev/null ${testSite})

  if [ "$response" -lt 400 ]; then
    printf "\n[  OK  ] Online! \n"
  else
    printf "\nO F F L I N E - N O T   C O N N E C T E D   T O   T H E   I N T E R N E T\n"
  fi
fi
