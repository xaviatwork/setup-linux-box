# Configurar una máquina virtual (VirtualBox)

La VM no tiene conexión a internet (por defecto), por lo que es preferible **no seleccionar la opción de descargar actualizaciones** o software de terceros durante la instalación.

## Configuración de la pantalla (*display*)

En *Settings > Display*, es necesario asignar como mínimo 64MB; en caso contrario, la pantalla se queda "en negro" al cambiar el tamaño de la ventana de Virtual Box.

## Configuración de USB

En Virtual Box 6.1 al arrancar la VM se muestra un error relacionado con el USB; es necesario *bajar* la compatibilidad a *USB 1.1 (OHCI) Controller*.

## Configurar VM en Virtual Box

### Instalar *VBox Additions*

En el menú *Dispositivos*, seleccionamos la opción *Insertar imagen de CD de las _Guest Additions*.

Esta acción *monta* el *disco* en la máquina virtual. Para instalar las *guest additions*, podemos hacer *doble click* sobre el fichero `autorun.sh`.

Tras realizar la instalación de las *guest additions*, reiniciamos la VM. De esta forma, la VM ya arranca con las extensiones que nos permiten compartir el puntero entre la VM y el equipo *host* así como redimensionar la ventana de la VM.

#### Entornos *GUI-less*

En entornos sin escritorio, montamos la ISO de las *Guest Additions* desde VirtualBox.

En la VM (por ejemplo, Ubuntu Server 20.04):

```bash
sudo mount /dev/cdrom /media/cdrom
cd /media/cdrom
sudo ./VBoxLinuxGuestAdditions.run
```

Tras la instalación de las *Guest Additions*, es necesario reiniciar la VM.

### Habilitar portapapeles bidireccional

En *Dispositivos > Portapapeles compartido* selecionamos *Bidireccional*.

### Habilitar carpeta compartida

> La configuración de la carpeta compartida debe realizarse con la VM apagada.

Siguiendo las instrucciones de la documentación oficial [7.31. VBoxManage sharedfolder add/remove](https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-sharedfolder.html), creamos un *script* en PowerShell para realizar el montaje de una carpeta local (en el equipo *host*, con Windows) en la VM.

> La carpeta compartida debe existir.

```powershell
$VirtualBox = "C:\Program Files\Oracle\VirtualBox\VBoxManage"

$vmName="vm-lite-01"
$shareName="shared"
$SharedFolder="C:\Users\MY_USERNAME\virtual-machines\vm-lite-01\vm-lite-01-shared"

Start-Process -NoNewWindow -Wait -FilePath $VirtualBox -Argument "sharedfolder add $vmName --name $shareName --hostpath $SharedFolder --automount"
```

Al arrancar la VM, la carpeta local se monta en `/media/sf_$shareName`.

#### Acceso a la carpeta compartida

```bash
$ ls -l /media/
drwxrwx---  1 root vboxsf    0 ene 16 19:46 sf_shared
```

La carpeta compartida ha sido montada por el usuario `root`; sólo el usuario `root` y los miembros del grupo `vboxsf` tienen acceso completo.

Añade el usuario al grupo `vboxsf` con el comando:

```bash
sudo usermod -aG vboxsf $USER
```

Los cambios tienen efecto en el siguiente inicio de sesión [^groups].

[^groups]: Puedes comprobar los grupos a los que pertenece tu usuario mediante el comando `groups`.
