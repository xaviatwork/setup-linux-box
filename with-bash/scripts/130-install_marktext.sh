#!/usr/bin/env bash

function install_marktext {

  latestVersion='https://github.com/marktext/marktext/releases/latest/download/marktext-x86_64.AppImage'
  icon="https://github.com/marktext/marktext/raw/develop/static/logo-small.png"

  if [ -z "$1" ]; then
    echo "[ WARN ] Installing from cache/ folder ..."
  else
    echo "[ INFO ] Downloading latest version of Mark Text ..."
    curl -JL $latestVersion -o cache/marktext.AppImage
    curl -JL $icon -o cache/marktext.png
  fi

  echo "[ INFO ] Copying marktext.AppImage to /usr/local/bin ..."
  sudo cp cache/marktext.AppImage /usr/local/bin/marktext.AppImage
  sudo chmod 755 /usr/local/bin/marktext.AppImage

  echo "[ INFO ] Copying marktext.png to /usr/local/share/icons ..."
  sudo mkdir -p /usr/local/share/icons
  sudo cp cache/marktext.png /usr/local/share/icons/marktext.png
  sudo chmod 444 /usr/local/share/icons/marktext.png

  echo "[ INFO ] Creating launcher file in /usr/share/applications ..."
  cat <<EOF >temp/marktext.desktop
[Desktop Entry]
Name=Mark Text
Comment=Edit markdown files.
GenericName=Markdown Text Editor
Exec=/usr/local/bin/marktext.AppImage --new-window
Icon=/usr/local/share/icons/marktext.png
Type=Application
StartupNotify=false
StartupWMClass=Code
Categories=Utility;TextEditor;Development;
MimeType=text/plain;text/markdown
Actions=new-empty-window;
Keywords=marktext;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=/usr/local/bin/marktext.AppImage --new-window %F
Icon=/usr/local/share/icons/marktext.png
EOF
  sudo mv temp/marktext.desktop /usr/share/applications/
  # sudo chmod 755 /usr/share/applications/marktext.desktop
}

install_marktext ""
