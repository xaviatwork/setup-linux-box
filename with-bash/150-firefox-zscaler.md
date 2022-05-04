# Configurar Certificado de Zscaler en Firefox

> No he conseguido configurar el certificado de forma programática.

Al intentar acceder a cualquier página vía HTTPS, se obtiene el mensaje:

```bash
Software is Preventing Firefox From Safely Connecting to This Site

www.wikipedia.org is most likely a safe site, but a secure connection could not be established. This issue is caused by Zscaler Root CA, which is either software on your computer or your network.
```

Instalar el certificado raíz de la entidad certificadora Zscaler:

- *Settings > Privacy & Security > Certificates > View Certificates ...*
- Seleccionamos la pestaña *Authorities > Import ...*
- El certificado raíz de Zscaler se encuentra en la carpeta `scripts/root-certificate-zscaler/zscaler-root-certificate.crt`
- Marcar la casilla ***Trust this CA to identify websites***
- Pulsar *Ok*.

Validar que podemos navegar con normalidad accediendo a `https://www.wikipedia.org`.
