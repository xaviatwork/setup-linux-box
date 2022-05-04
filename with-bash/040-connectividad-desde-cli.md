# Comprobar conectividad desde la CLI

El script permite comprobar si hay conectividad vía HTTP(S) hacia internet (por defecto, accediendo a `www.google.com`).

Aprovechamos que en BASH una variable se trata como *integer* o como *string* en función del contexto para revisar si el código HTTP devuelto por el sitio web de *test* es menor de `400`. Los códigos `1xx` (*informational*), `2xx` (*Success*) y `3xx` (*redirection*) indican que la salida a internet funciona; los códigos 400 (*Client Error*) y 500 (*Server error*) son errores ([List of HTTP status codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)).

```bash
#!/usr/bin/env bash

testSite="https://www.google.com"

if [ -z $https_proxy ]
then
    echo "\$https_proxy is not set"
else
    echo "Checking internet connectivity..."

    response=$(curl -k --write-out '%{http_code}' --silent --head --output /dev/null ${testSite})

    if [ $response -lt 400 ]
    then
          echo "Online!"
    else
          echo "O F F L I N E - N O T   C O N N E C T E D   T O   T H E   I N T E R N E T"
    fi
fi
```
