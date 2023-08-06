#!/usr/bin/env bash

fontIosevkaTerm_version='26.0.1'
fontIosevkaTermURL=https://github.com/be5invis/Iosevka/releases/download/v${fontIosevkaTerm_version}/ttf-iosevka-term-${fontIosevkaTerm_version}.zip
fontIosevkaTermPkgName="ttf-iosevka-term-${fontIosevkaTerm_version}.zip"

function install_font(){
    if [ -d "${HOME}/.local/share/fonts-" ]
    then
        echo "[ INFO ] ${HOME}/.local/share/fonts already exists..."
    else
        mkdir -p ${HOME}/.local/share/fonts/iosevka
        unzip ${fontIosevkaTermPkgName} -d ${HOME}/.local/share/fonts/iosevka
        fc-cache --force --verbose
    fi
}

update_vscode_settings() {
    vscode_user_settings_file="$HOME/.config/Code/User/settings.json"
    if [[ ! -f ${vscode_user_settings_file} ]]; then
        echo "[ INFO ] Create empty user's settings.json file"
        echo "{}" >> ${vscode_user_settings_file}
    fi 

    echo "[ INFO ] Checking current font in VSCode"
    current_fonts=$(jq -r '."editor.fontFamily"' ${vscode_user_settings_file})

    if [[ ${current_fonts} == "null" ]]; then
        echo "[ INFO ] Using default fonts (no user customization)"
        current_fonts="'Droid Sans Mono', 'monospace', monospace"
    fi
    if ! echo ${current_fonts} | grep -i 'iosevka termm' ; then
        fonts="'Iosevka Term', ${current_fonts}"
        jq --arg fonts "${fonts}" '."editor.fontFamily" = $fonts' ${vscode_user_settings_file} > ${vscode_user_settings_file}.tmp && mv ${vscode_user_settings_file}.tmp ${vscode_user_settings_file}
    fi
}


if [ -f ${fontIosevkaTermPkgName} ]
then
    echo "[ INFO ] ${fontIosevkaTermPkgName} version ${fontIosevkaTerm_version} already downloaded..."
else
    curl -JLO $fontIosevkaTermURL
fi
# install_font
update_vscode_settings