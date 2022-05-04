# Configurar el proxy para aplicaciones CLI

En general, las aplicaciones en Linux usan, si se encuentra configurada, la variable de entorno `https_proxy` (y `http_proxy`) [^envvariablescase].

Como el comando `export` únicamente *exporta* la variable de entorno al proceso *child* desde donde se lanza el comando, usamos un método *indirecto*: creamos un fichero de configuración y usamos `source` desde `.bashrc`:

```bash
function configure_http_proxy_env_vars () {
    proxyURL_PORT="$1"
    if [[ -z "${proxyURL_PORT}" ]]
    then
        proxyURL_PORT=$defaultProxyURL_PORT
    fi

    http_proxy="http://${proxyUser}:${proxyPasswd}@${proxyURL_PORT}" 
    
    # Always create a new file
    echo "# ENV vars to configure CLI proxy" > ${HOME}/.http_proxy.conf
    echo "export http_proxy=http://${proxyUser}:${proxyPasswd}@${proxyURL_PORT}" >>  ${HOME}/.http_proxy.conf
    echo "export https_proxy=${http_proxy}" >>  ${HOME}/.http_proxy.conf

    # Include it to .bashrc if it is not already present
    # https://stackoverflow.com/questions/3557037/appending-a-line-to-a-file-only-if-it-does-not-already-exist
    grep -qxF "source \"${HOME}/.http_proxy.conf\"" ${HOME}/.bashrc || echo "source \"${HOME}/.http_proxy.conf\"" >> ${HOME}/.bashrc
    


    echo
    echo "[ OK ] Open a new terminal session to load your .bashrc file again"
    echo "       -----------------------------------------------------------"
    cat ${HOME}/.http_proxy.conf
    echo
}
```

[^envvariablescase]: En la documentación de AWS CLI [Using an HTTP proxy](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-proxy.html) se indica que si la misma variable de entorno se define en mayúsculas y en minúsculas, la definida **con minúsculas** se evalúa primero.
