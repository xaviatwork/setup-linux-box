# AWS CLI v2

AWS CLI no está incluido en los repositorios de Ubuntu.

La instalación se realiza descargando el paquete desde la web de Amazon.

Antes de lanzar la instalación, comprobamos los requerimientos indicados en la documentación oficial: [Installing or updating the latest version of the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html):

```bash
function _check_awscli_requirements () {
    # unzip glibc, less, groff
    unzip -v 2>&1 1>/dev/null
    if [ $? != 0 ]
    then
        echo "[ ERR ] Unzip is required to install AWS CLI"
        exit $ERR_UNZIP_REQUIRED
    fi

    ldd --version 2>&1 1>/dev/null
    if [ $? != 0 ]
    then
        echo "[ ERR ] GLIBC is required by AWS CLI"
        exit $ERR_GLIBC_REQUIRED
    fi

    less --version 2>&1 1>/dev/null
    if [ $? != 0 ]
    then
        echo "[ ERR ] LESS is required by AWS CLI"
        exit $ERR_LESS_REQUIRED
    fi

    echo "[ OK ] AWS CLI installation requirements checked"
}
```

Para evitar descargar el paquete de instalación innecesariamente, en primer lugar comprobamos si AWS CLI está instalada:

```bash
function _is_aws_installed () {
    aws --version 2>&1 1>/dev/null
    if [ $? != 0 ]
    then
        echo "no"
    else
        echo "yes"
    fi
}
```

Usamos cualquier parámetro no vacío para la función `install_awscli` como *flag* para forzar la instalación de AWS CLI. Por ejemplo, `install_awscli force` o `install_awscli always`.

La presencia de un parámetro no vacío para `install_awscli` hace que no se verifique si AWS CLI ya está instalado.
Comprobamos si el paquete `awscliv2.zip` está presente para evitar descargarlo de nuevo.

> Si se fuerza la instalación con `install_awscli force`, el fichero `awscliv2.zip` se borra antes de realizar la instalación.

La instalación de AWS CLI v2 se realiza usando el *flag* `--update`, que actualiza la versión de AWS CLI si ya está instalada una versión anterior. Si el *zip* contienen la misma versión de AWS CLI instalada, se evita la reinstalación.

Finalmente, eliminamos los ficheros descomprimidos (aunque conservamos el *zip*).

```bash
function install_aws_cli () {
    # https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
    forceInstall=$1
    _check_awscli_requirements

    if [[ -z $forceInstall ]]
    then
        awscliInstalled=$( _is_aws_installed )
      else
        if [[ -f "cache/awscliv2.zip" ]]
        then
        echo "[ INFO ] Removing awscliv2.zip ..."
        rm cache/awscliv2.zip
        fi
    fi

    if [[ $awscliInstalled != "yes" ]]
    then
        echo "[ INFO ] Installing AWS"
        if [[ -f "cache/awscliv2.zip" ]]
        then
            echo "[ WARN ] awscliv2.zip already present"
        else
            echo "[ INFO ] Downloadinng awscliv2.zip ..."
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "cache/awscliv2.zip"
        fi

        echo "[ INFO ] Unzipping awscliv2.zip ..."
        local tempFolder="temp/awscli"
        mkdir -p $tempFolder
        unzip cache/awscliv2.zip -o $tempFolder
        echo "[ INFO ] Installing AWS CLI ..."
        sudo $tempFolder/aws/install --update
        echo "[ INFO ] Cleaning unzipped files ..."
        rm -rf $tempFolder
        
    else
        echo "[ INFO ] AWS already installed"
        echo "         Use 'install_awscli force' to force installation"
        aws --version
    fi
}
```
