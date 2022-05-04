#!/usr/bin/env bash

function install_oc_client {
    # Downloading from the "stable" repository
    # The "latest" version can be downloaded from
    # https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/
    oc_download_url="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux.tar.gz"
    if [[ -f "cache/openshift-client-linux.tar.gz" ]]; then
        echo "[ WARN ] Using cached file..."
    else
        echo "[ INFO ] Downloading oc.tar.gz to cache/ dir ..."
        # https://gist.github.com/jwebcat/5122366
        curl -LJ $oc_download_url -o cache/openshift-client-linux.tar.gz
    fi

    local tempFolder="temp/"
    echo "[ INFO ] Uncompressing to $tempFolder ..."
    tar -xvf ./cache/openshift-client-linux.tar.gz --directory temp/
    echo "[ INFO ] Copying to /usr/local/bin"
    sudo cp ./temp/{oc,kubectl} /usr/local/bin
    echo "[ INFO ] Testing ..."

    if [[ "$(oc version)" -eq 0 ]]; then
        echo "[ INFO ] Successful installation."
        rm temp/*
    fi
}

install_oc_client
