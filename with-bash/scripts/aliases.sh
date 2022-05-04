#!/usr/bin/env bash

customAliasesFile="${HOME}/.custom_aliases.conf"

function add_alias_if_it_not_exists {
  local custom_alias="$1"
  grep -qxF "${custom_alias}" "${customAliasesFile}" || echo "${custom_alias}" >>"${customAliasesFile}"
}

# check if the custom_aliases.conf file is present in ~/.bashrc
if [[ ! -f "${customAliasesFile}" ]]; then
  echo "# Custom aliases" | tee "${customAliasesFile}"
fi

grep -qxF "source ${customAliasesFile}" "${HOME}/.bashrc" || echo "source ${customAliasesFile}" >>"${HOME}/.bashrc"
# Add custom aliases below
# ------------------------
add_alias_if_it_not_exists 'alias open=xdg-open'
