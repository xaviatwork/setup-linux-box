# Configurar el certificado de ZScaler

Zscaler actúa como intermediario en todas las conexiones HTTPS desde la red interna hacia el exterior. Las aplicaciones requieren el certificado de ZScaler para conectar con servicios externos usando HTTPS.

Validamos si el certificado para ZScaler se encuentra instalado (y si es el mismo que proporcionamos); en caso de que no esté instalado (o que sea un certificado diferente), lo copiamos a `/usr/local/share/ca-certificates/` y actualizamos para que los cambios tengan efecto:

```bash
#!/usr/bin/env bash

ZscalerCertPath="./root-certificate-zscaler"
ZscalerCertFileName="zscaler-root-certificate.crt"

function getMD5sum () {
    file="$1"
    echo $(md5sum ${file} | awk '{print $1}')
}

ZscalerCertMD5sum=$(getMD5sum "${ZscalerCertPath}/${ZscalerCertFileName}")


if [[ -f "/usr/local/share/ca-certificates/${ZscalerCertFileName}" ]]
then
    echo "[ WARN ] Cert file ${ZscalerCertFileName} already present in /usr/local/share/ca-certificates/"
    installedCertMD5sum=$(getMD5sum "/usr/local/share/ca-certificates/${ZscalerCertFileName}")
    if [[ $installedCertMD5sum == $ZscalerCertMD5sum ]]
    then
        echo "[ OK ] The provided ZScaler certificate is already installed"
    fi
else
    sudo cp ./zscaler-root-certificate/zscaler-root-certificate.crt /usr/local/share/ca-certificates
    sudo update-ca-certificates
    echo "[ OK ] Installed the provided ZScaler certificate"
fi
```
