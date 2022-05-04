# Instalar Git Remote CodeCommit

Git Remote CodeCommit permite usar las credenciales de un perfil configurado en la AWS CLI para acceder a AWS CodecCommit.

Para instalar Git Remote CodeCommit, se requiere Python3 y PIP.

> En vez de usar una función de comprobación de requisitos específica como en el caso de AWS CLI (`_check_awscli_requierements`), usamos funciones específicas para Python3 y PIP que podremos reutilizar para la instalación de otras aplicaciones.

Para comprobar los requisitos necesarios para instalar Git Remote CodeCommit, usamos el *flag* `--version` y observamos el código de salida del comando.

Para Python3, la salida del comando `python --version` es `Python 3.8.10`, por lo que usamos `awk` dos veces; primero para obtener el número de versión y después para quedarnos únicamente con el número de versión *major*:

> En Ubuntu Server 20.04 `python --version` devuelve un error, aunque `python3` está instalado.
>
> Podemos configurar `python3` como versión de Python por defecto con el comando:
>
> ```bash
> sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
> ```

```bash
function _is_python3_installed () {
    pythonMajorVersion=$(python --version | awk '{print $2}' | awk -F '.' '{print $1}')
    if [[ $pythonMajorVersion -ge 3 ]]
    then
        echo "yes"
    else
        echo "no"
    fi
}
```

Para PIP:

```bash
function _is_pip_installed () {
    pip --version 2>&1 1>/dev/null
    if [ $? != 0 ]
    then
        echo "no"
    else
        echo "yes"
    fi
}
```

Estas funciones auxiliares las usamos en:

```bash
function install_aws_git_remote_codecommit () {
    # https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-git-remote-codecommit.html
    pythonInstalled=$(_is_python3_installed)
    pipInstalled=$(_is_pip_installed)

    if [[ $pythonInstalled == "yes" ]]
    then
        if [[ $pipInstalled == "yes" ]]
        then
            echo "[ WARN ] PIP already installed"
            pip --version
        else
            echo "[ INFO ] Installing PIP ..."
            sudo apt-get install python3-pip -y
        fi
    else
        echo "[ ERROR ] Python3 or greater is requied"
        exit $ERR_PYTHON3_REQUIRED
    fi

    echo "[ INFO ] Installing Git Remore CodeCommit ..."
    pip install git-remote-codecommit
    
    # PIP complains when installed in $HOME/.local/bin
    grep -i -q 'PATH=\"$HOME/.local/bin' ~/.profile 
    if [[ $? == 0 ]]
    then
        echo "[ INFO ] $HOME/.local/bin is already in the PATH"
        echo "         Ignore the PIP warning and start a new terminal session"
    else
        echo "[ WARN ] Add $HOME/.local/bin to \$PATH ..."
        echo "         See https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path"
    fi
}
```
