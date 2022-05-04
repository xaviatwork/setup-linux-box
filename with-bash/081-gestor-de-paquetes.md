# Instalar aplicaciones con el gestor de paquetes

El *Script* contiene un comando `apt install` seguido de los paquetes a instalar (ordenados por orden algfabético):

> Consulta los paquetes incluidos en el fichero `apt_install.sh`

```bash
#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y \
    git \
    jq  \
    tmux \
    tree \
    vim 
```
