# Carpetas *auxiliares*

> Los *scripts* deben ejecutarse desde la carpeta `scripts/` a no ser que se indique lo contrario.

## Carpeta `cache/`

Varios *scripts* usan la carpeta `cache/` para guardar una copia local de los instalables. Si existe una versión del paquete en la carpeta `cache/`, el *script* de instalación usa esta copia (en vez de descargar nuevamente el paquete desde internet). Revisa el *script* ya que generalmente se acepta un parámetro no vacío para *forzar* la descarga del paquete y así instalar la última versión existente.

## Carpeta `temp/`

En esta carpeta se extraen aquellos paquetes descargados en forma de archivo comprimido. En general, el *script* elimina el contenido de la carpeta al finalizar la instalación del paquete, por lo que esta carpeta (vacía) no se guarda en el repositorio.

## Carpeta `local/`

La carpeta `local/` se ignora a través del fichero `.gitignore`.

Esto permite incluir ficheros con configuraciones locales específicas para la máquina así como valores sensibles que sería inadecuado publicar en el repositorio de código (aunque no se *ignora* explíctiamente en el fichero `.gitignore`).
