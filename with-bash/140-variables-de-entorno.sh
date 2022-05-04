# Configurar variables de entorno de utilidad

El *script* `envvars_conf.sh` permite configurar variables de entorno de utilidad como `AWS_DEFAULT_REGION`, *access_keys* o nombres de instancias EC2 (por ejemplo, un *jumpserver*) para acceder a ellas de forma sencilla al trabajar desde la línea de comando.

Algunas de estas variables podrían ser:

- AWS_DEFAULT_REGION
- AWS_PROFILE
- OCP_USER
- OCP_PASSWD
- OCP_LOGIN_URL
- JUMPLINUX
- GH_TOKEN

Para evitar guardar valores sensibles en el repositorio, el *script* carga, si existe, el fichero `local/envvars.conf`. Los ficheros en la carpeta `local/` se ignoran en Git.

```bash
#!/usr/bin/env bash
# Define variables like usernames, instanceIds, etc for easy access from CLI

envvarsFile="${HOME}/.env_vars.conf"

if [ -f local/envvars.conf ]
then
    echo "[ INFO ] Using variables from local/envvars.conf file ..."
    source local/envvars.conf
fi

echo 'AWS_DEFAULT_REGION=eu-central-1' >> $envvarsFile

grep -qxF "source \"${envvarsFile}\"" ${HOME}/.bashrc || echo "source \"${envvarsFile}\"" >> ${HOME}/.bashrc
```

El contenido de `local/envvars.conf` es de la forma:

```bash
echo 'OCP4_DEV_URL="https://api.example.com:6443"' >> $envvarsFile
echo 'OCP4_DEV_PASSWD="R@Nd0M_P@55W0rd;)"' >> $envvarsFile
```
