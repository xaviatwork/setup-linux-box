# Instalar aplicaciones

La instalación de aplicaciones está dividida en tres bloques:

- Aplicaciones que se instalan desde el gestor de paquetes: `apt_install.sh`
- Aplicaciones adicionales: En esta categoría se incluyen todas aquellas aplicaciones que requieren instruciones específicas para su instalación y/o configuración. La instalación de cada aplicación se realiza desde una función como `install_vscode`. Esta función puede usar funciones auxiliares (funciones que distinguimos porque el nombre de la función comienza con `_`) o funciones importadas desde ficheros auxiliares, de uso más general.
- Aplicaciones alternativas a las presentes en el sistema operativo que ofrecen funcionalidad adicional: `linux_tools_improved.sh`
