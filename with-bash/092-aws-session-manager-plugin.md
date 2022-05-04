
# Instalar Session Manager Plugin

El *plugin* de Session Manager permite conectar a las instancias en AWS desde la línea de comando, por lo que resulta una alternativa a SSH.

La instalación se realiza mediante un paquete `deb` que descargamos a la carpeta de *cache* y desde donde instalamos usando `dpkg`

```bash
function install_aws_session_manager_plugin () {
    # https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-debian
    awscliInstalled=$( _is_aws_installed )
    
    if [[ $awscliInstalled == "yes" ]]
    then
        echo "[ OK ] AWS CLI installed"
        aws --version

        if [[ -f "session-manager-plugin.deb" ]]
        then
            echo "[ WARN ] Session Manager package already present"
            session-manager-plugin
        else
            echo "[ INFO ] Downloading Session Manager plugin ..."
            curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "cache/session-manager-plugin.deb"
        fi
        sudo dpkg -i cache/session-manager-plugin.deb
    else
        echo "[ ERROR ] AWS CLI is required for AWS Session Manager plugin"
        exit $ERR_AWSCLI_REQUIRED
    fi
}
```
