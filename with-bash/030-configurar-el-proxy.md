# Configurar el proxy

Usamos un *script* para realizar la configuración del proxy para las diferentes herramientas que requieren una configuración especial.

Si las variables de entorno `SET_HTTP_PROXY` y `SET_APT_PROXY` no están definidas (o contienen cualquier valor diferente a `"false"`), se solicta el usuario y contraseña para configurar el proxy.

```bash
if [ -z "${SET_HTTP_PROXY}" ] || [ -z "${SET_APT_PROXY}" ]
then
  proxyUser=$(request "Enter proxy user" "MY_USERNAME")
  proxyPasswd=$(request_sensitive "Enter proxy password")
fi
```

> Las funciones `request` y `request_sensitive` son *scripts auxiliares* que se encuetran en la carpeta `aux_scripts/`.

## Configuración de `no_proxy`

Si para el acceso a determinadas URLs (como por ejemplo, las internas) no es necesario pasar a través del proxy, es necesario especificar **los dominios** en la variable `no_proxy`.

Para ello se incluye en el *script* la variable `NoProxyDomainList`, en la que incluir una lista separada de dominios.

El *script* comprueba si existe el fichero `local/noproxy.conf` para cargar los valores de la variable `no_proxy` desde ahí. La carpeta `local/` se *ignora* a través del fichero `.gitignore`, lo que permite no guardar en el repositorio configuraciones locales/específicas de la máquina.

```bash
if [ -f local/noproxy.conf ]
then
    echo "[ INFO ] Using no_proxy from temp/noproxy.conf ..."
    source local/noproxy.conf
fi
```

El contenido del fichero `local/noproxyconf` es de la forma:

```bash
export NoProxyDomainList=".local,.internal"
```

> Si la variable está vacía, se usan los valores definidos en el *script*

```bash
if [ -z NoProxyDomainList ]
then
    NoProxyDomainList=".local,.internal"
fi
```

Se recomienda establecer los dominios internos (sin proxy) al ejecutar el *script* (de esta forma no se publica información en GitHub sobre dominios internos de la organización):

```bash
NoProxyDomainList='example-internal.com,intranet.local' ./proxy.sh
```

De esta forma, todos los subdominios de `example-internal.com` y `intranet.local` no pasarán por el proxy.
