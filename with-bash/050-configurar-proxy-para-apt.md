# Configurar el proxy para `apt`

La configuración del proxy para la herramienta `apt` se realiza mediante un fichero de configuración en `/etc/apt/apt.conf.d/`. Usaremos el nombre `proxy.conf` para el fichero de configuración del proxy.

```bash
defaultProxyURL_PORT="11.22.33.44.:80"
aptConfLocation="/etc/apt/apt.conf.d"

function configure_apt_proxy () {
    proxyURL_PORT="$1"
    if [[ -z "${proxyURL_PORT}" ]]
    then
        proxyURL_PORT=$defaultProxyURL_PORT
    fi

    if [[ -f  "${aptConfLocation}/proxy.conf" ]]
    then
        echo "[ WARN ] File ${aptConfLocation}/proxy.conf already exists"
        echo "[ WARN ] Current file content:"
        echo
        cat "${aptConfLocation}/proxy.conf"
    else

        http_proxy="http://${proxyUser}:${proxyPasswd}@${proxyURL_PORT}" 
        
        # Always create a new file
        echo "# PROXY settings" | sudo tee ${HOME}/.http_proxy.conf
        echo "Acquire::http::proxy \"${http_proxy}\";" | sudo tee -a "${aptConfLocation}/proxy.conf"
        echo "Acquire::https::proxy \"${http_proxy}\";" | sudo tee -a "${aptConfLocation}/proxy.conf"
    fi
    echo
    echo "[ OK ] Proxy configuration set for APT!"
}
```
