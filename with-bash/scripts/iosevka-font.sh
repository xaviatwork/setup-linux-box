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

if [ -f ${fontIosevkaTermPkgName} ]
then
    echo "[ INFO ] ${fontIosevkaTermPkgName} version ${fontIosevkaTerm_version} already downloaded..."
else
    curl -JLO $fontIosevkaTermURL
fi

install_font