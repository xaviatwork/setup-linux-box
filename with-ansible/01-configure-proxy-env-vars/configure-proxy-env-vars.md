# Configuración de las variables de entorno del proxy

En mi escenario, es necesario configurar:

- acceso autenticado a través del proxy. Esta configuración se realiza a través de las variables de entorno `http_proxy` y `https_proxy`.
- configuración específica para aplicaciones que no usan las variables de entorno
- certificado de ZScaler

## Requerimientos

1. El *script* carga las variables de un fichero de configuración `proxy.defaults` con los valores por defecto.
Para aquellas variables no definidas en el fichero de valores por defeto, se solicitan al usuario los valores pendientes.
1. Con los valores obtenidos, se genera el fichero `$HOME/proxy.vars`. Este fichero puede ser usado como punto de referencia para la configuración del resto de *scripts*.
1. El *script* genera un fichero `$HOME/proxy.conf` en el que se definen las variables de entorno de configuración del proxy `http_proxy`, `https_proxy` y `no_proxy`.
1. El *script* modifica el fichero `$HOME/.profile` para añadir la línea `source $HOME/proxy.conf`. El fichero `$HOME/.profile` se evalua durante el *login*, independientemente de la *shell* definida por el usuario.
