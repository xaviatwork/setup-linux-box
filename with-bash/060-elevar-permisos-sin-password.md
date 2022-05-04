# Elevar permisos sin contraseña

Usamos `grep` para comprobar si la línea ya se encuentra en el fichero `/etc/sudoers` antes de añadirla (si no lo está):

```bash
sudo grep -qxF "$USER ALL=(ALL) NOPASSWD:ALL" /etc/sudoers || echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo
```
