# Configurar el certificado de ZScaler

Zscaler actúa como intermediario en todas las conexiones HTTPS desde la red interna hacia el exterior. Las aplicaciones requieren el certificado de ZScaler para conectar con servicios externos usando HTTPS.

Validamos si el certificado para ZScaler se encuentra instalado (y si es el mismo que proporcionamos); en caso de que no esté instalado (o que sea un certificado diferente), lo copiamos a `/usr/local/share/ca-certificates/` y actualizamos para que los cambios tengan efecto:
