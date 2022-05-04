# Instalar cliente `oc`

La descripción de la instalación del cliente `oc` se encuentra en la sección [Getting started with the OpenShift CLI](https://docs.openshift.com/container-platform/4.7/cli_reference/openshift_cli/getting-started-cli.html) de la documentación de OpenShift.

La documentación indica como ubicación para la descarga del cliente la URL [Download Red Hat OpenShift Container Platform](https://access.redhat.com/downloads/content/290/), que requiere acceso al Red Hat Customer Portal.

En la documentación sobre OKD (la versión *opensource* de OpenShift), la página [Getting started with the OpenShift CLI](https://docs.okd.io/4.9/cli_reference/openshift_cli/getting-started-cli.html), indica que se puede descargar el cliente `oc` desde <https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/>.

El *script* `install_oc_client.sh` descarga la versión estable del cliente (si no está cacheada en la carpeta `cache/`) y la instala en `/usr/local/bin`.
