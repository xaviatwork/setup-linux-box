# Configuración de máquina con Linux

## Escenario

En mi entorno de trabajo, el sistema operativo del portátil asignado a los usuarios es MS Windows.

Sin embargo, mi trabajo está relacionado con la automatización y el *cloud*. En este escenario, lo habitual es trabajar desde la línea de comando y en entornos Linux.

Otro elemento relevante del entorno de trabajo es que la salida a internet está restringida por diversos mecanismos, como un *proxy* que requiere autenticación y la inspección de las comunicaciones web (incluidas las que usan HTTPS).

## Opciones

### Windows (+WSL)

Aunque es posible instalar BASH en Windows [^bashonwindows], algunos aspectos como la diferencia entre los caracteres de final de línea entre Windows y Linux complican trabajar en un entorno *híbrido*.

Hace un tiempo estuve usando WSL (el subsistema de Linux para Windows), pero lo abandoné debido a los problemas que encontré. Los repositorios en Git mostraban como *modified* o *untracked* en Windows mientras que el repositorio estaba *clean* en WSL (o viceversa). Las configuraciones en la carpeta `$HOME` (en WSL) no se reflejaban en Windows (o viceversa), etc... La mayor parte de estos problemas surgían al usar las mismas herramientas *dentro* y *fuera* de WSL: git, aws cli, etc.

En otros casos, aunque parece que la herramienta está disponible en ambos entornos -por ejemplo, `curl`-, en realidad no es así; `curl`, en PowerShell es un *alias* a un *cmdlet* propio, [`invoke-webrequest`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.2), que es compatible al 100% (a nivel de opciones) con `curl`. Además, al tener que configurar el proxy, era necesario realizar la configuración dos veces: en Windows y en Linux. El proxy requiere autenticación, de manera que con cada cambio de contraseña, haya que modificar la configuración periódicamente...

La situación con el Gestor de Credenciales de Windows (y en especial, con Git y/o CodeCommit) fue otro motivo que hizo que la opción de trabajar de forma *híbrida* fuera poco menos que imposible. Usando el protocolo *git*, todos los repositorios de CodeCommit tienen la URL `https://git-codecommit.<region>.amazonaws.com`. El Gestor de Credenciales almacena las credenciales no se muestra ninguna opción (o indicador) para saber qué credencial se está usando en cada momento... De manera que trabajar con diferentes usuarios en diferentes repositorios falla con acceso denegado (suponiendo que Git haya *superado* el proxy para salir hacia internet).

Con WSL 2 fui incapaz de configurar el acceso a internet.

Hay que tener en cuenta que los permisos de administrador en el equipo son temporales, por lo que la obtención de los permisos supone un punto adicional de fricción a la hora de, por ejemplo, tener que actualizar determinadas herramientas.

### Instancia remota Linux

De nuevo, el principal problema es la conectividad. Las conexiones SSH hacia equipos externos estás restringidos a nivel de Firewall, por lo que

[^bashonwindows]: [How to Install Linux Bash Shell on Windows 10](https://itsfoss.com/install-bash-on-windows/)
