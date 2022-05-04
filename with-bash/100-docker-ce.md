# Instalar Docker CE

Instalamos Docker-CE usando las instrucciones oficiales de la página de Docker: [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

```bash
function install_docker () {
    # https://docs.docker.com/engine/install/ubuntu/
    echo "[ INFO ] Installing Docker requirements ..."
    sudo apt-get remove -y docker docker-engine docker.io containerd runc
    sudo apt-get install -y ca-certificates curl gnupg lsb-release
    echo "[ INFO ] Instaling Docker GPG repository key ..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "[ INFO ] Adding Docker repo ..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    echo "[ INFO ] Installing Docker-CE ..."
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    echo "[ WARN ] Adding $USER to docker group ..."
    sudo usermod -aG docker $USER
}
```

## Configurar proxy para Docker

Para poder descargar imágenes de registros externos, es necesario configurar Docker CE para usar el proxy; para ello, usamos:

```bash
function configure_proxy_for_docker(){
    # https://stackoverflow.com/questions/48056365/error-get-https-registry-1-docker-io-v2-net-http-request-canceled-while-b
    proxyURLstring='Environment="https_proxy=http://11.22.33.44.:80/"'
    restarService='false'
    systemdDockerService='/lib/systemd/system/docker.service'
    

    isProxyConfigured=$(cat $systemdDockerService | grep  "Environment")
    if [ "$isProxyConfigured" ]
    then
        echo "[ INFO ] Proxy Configured: $isProxyConfigured ..."
        restarService='false'
    else
        echo "[ INFO ] Adding Proxy to $systemdDockerService ... "
        sudo sed -i 's|\[Service\]|[Service]\nEnvironment="https_proxy=http://11.22.33.44.:80/"|g' $systemdDockerService
        restarService='true'
    fi

    if [ "$restarService" == 'true' ]
    then
        echo "[ INFO ] Reloading and restarting Docker daemon ..."
        sudo systemctl daemon-reload
         sudo systemctl restart docker
    fi
}
```