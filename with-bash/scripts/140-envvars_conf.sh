#!/usr/bin/env bash

# Define variables like usernames, instanceIds, etc for easy access from CLI

envvarsFile="${HOME}/.env_vars.conf"

# Examples
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
# echo 'AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE' >> $envvarsFile
# echo 'AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY' >> $envvarsFile

if [ -f local/envvars.conf ]; then
  echo "[ INFO ] Using variables from local/envvars.conf file ..."
  source local/envvars.conf
fi

echo 'AWS_DEFAULT_REGION=eu-central-1' >>"$envvarsFile"

grep -qxF "source \"${envvarsFile}\"" "${HOME}"/.bashrc || echo "source \"${envvarsFile}\"" >>"${HOME}"/.bashrc
