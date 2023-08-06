#!/usr/bin/env bash
vscode_user_settings_file="$HOME/.config/Code/User/settings.json"

if [[ ! -f ${vscode_user_settings_file} ]]; then
    echo "Create empty user's settings.json file"
    echo "{}" >> ${vscode_user_settings_file}
fi 
echo "Extension: MardownLint"
code --install-extension DavidAnson.vscode-markdownlint
echo "Theme: Night Owl"
code --install-extension sdras.night-owl
current_theme=$(jq '."workbench.colorTheme"' ${vscode_user_settings_file}) 
if [[ ${current_theme} == "null" || ${current_theme} != "Night Owl" ]];then
	jq '."workbench.colorTheme"="Night Owl"' ${vscode_user_settings_file} > ${vscode_user_settings_file}.tmp && mv  ${vscode_user_settings_file}.tmp ${vscode_user_settings_file}
fi

echo "Icons: VSCode Icons"
code --install-extension vscode-icons-team.vscode-icons

current_icons=$(jq '."workbench.iconTheme"' ${vscode_user_settings_file}) 
if [[ ${current_icons} == "null" || ${current_icons} != "vscode-icons" ]];then
	jq '."workbench.iconTheme"="vscode-icons"' ${vscode_user_settings_file} > ${vscode_user_settings_file}.tmp && mv  ${vscode_user_settings_file}.tmp ${vscode_user_settings_file}
fi

echo "Extension: Remote Development"
echo " - Remote SSH"
echo " - Remote Tunnels"
echo " - Dev Containers (Requires Docker)"
echo " - WSL"
code --install-extension ms-vscode-remote.vscode-remote-extensionpack
echo "Extension: Go"
code --install-extension golang.Go
