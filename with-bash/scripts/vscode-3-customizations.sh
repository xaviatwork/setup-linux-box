#!/usr/bin/env bash
vscode_user_settings_file="$HOME/.config/Code/User/settings.json"

set_sidebar_to_the_right() {
    if [[ $(jq '."workbench.sideBar.location"' ${vscode_user_settings_file}) == "null" ]]; then
        echo "[ INFO ] Not customized, using default value (left)"
        echo "         Move workbench to the right" 
        jq '."workbench.sideBar.location" = "right"' ${vscode_user_settings_file} > ${vscode_user_settings_file}.tmp && mv ${vscode_user_settings_file}.tmp ${vscode_user_settings_file}
    fi
}


if [[ ! -f ${vscode_user_settings_file} ]]; then
    echo "Create empty user's settings.json file"
    echo "{}" >> ${vscode_user_settings_file}
fi

set_sidebar_to_the_right