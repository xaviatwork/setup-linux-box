# Instalar Visual Studio Code

VSCode no se encuentra en los repositorios de Ubuntu.

La instalación se puede realizar descargando el paquete `deb` [^repovscode] o bien añadiendo el repositorio de Microsoft; las actualizaciones se realizan a través del gestor de paquetes mediante `apt update`.

El *script* comprueba si puede instalar VSCode desde el repositorio; si no se encuentra el paquete, se configura el repositorio de Microsoft y se instala a través del gestor de paquetes `apt`.

```bash
function install_vscode () {
    sudo apt-get install code 2>/dev/null
    if [ $? -eq $ERR_UNABLE_TO_LOCATE_PACKAGE ]
    then
        echo "[ WARN ] VSCode repository is not configured"
        echo "         Package code cannot be located."
        echo " ... configuring"
        # https://code.visualstudio.com/docs/setup/linux
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        rm -f packages.microsoft.gpg
        sudo apt-get update && sudo apt-get install apt-transport-https code -y
    else
        echo "[ INFO ] VSCode repository configured"
        echo "  ... installing]"
        sudo apt-get update && sudo apt-get install apt-transport-https code -y
    fi
}
```

## Instalar extensiones de VSCode

Debido a los problemas para proporcionar un método sencillo para instalar las extensiones de VSCode desde la CLI y que la selección de extensiones es un tema *personal*, se recomienda realizar la instalación de forma manual.

> La opción de instalar desde la CLI falla con el mensaje de error
>
> ```bash
> $ code --install-extension DavidAnson.vscode-markdownlint
> Installing extensions...
> unable to get local issuer certificate
> ```
>
> El problema parece relacionado con el proxy [unable to get local issuer certificate vscode](https://stackoverflow.com/questions/34921875/unable-to-get-local-issuer-certificate-vscode).
> Se podría explorar la posibilidad de copiar las extensiones desde el equipo *host* mediante la carpeta compartida.aprovechando que las extensiones de VSCode se actualizan automáticamente [^vscodeextensionautoupdate].

Algunas extensiones recomendadas:

- [markdownLint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)
- [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- [Night Owl (*theme*)](https://marketplace.visualstudio.com/items?itemName=sdras.night-owl)
- [vscode-icons](https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons) (*icons*)

[^repovscode]: Al instalar VSCode desde el paquete `deb` se configuran automáticamente el repositorio; las actualizaciones se realizan usando `apt update`.

[^vscodeextensionautoupdate]: [Mange extension](https://code.visualstudio.com/docs/editor/extension-marketplace#_manage-extensions)
