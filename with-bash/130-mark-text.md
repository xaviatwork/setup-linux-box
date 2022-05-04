# Instalar *Mark Text* (editor de markdown)

[*Mark Text*](https://marktext.app/) es un editor de texto en formato markdown, multiplataforma y *opensource*.

*Mark Text* se distribuye en formao *AppImage*, de manera que es *portable* (no requiere instalación).

El *script* de instalación descarga y copia a `/usr/local/bin` el fichero de la aplicación.

El *logo/icono* para el *lanzador* se descarga desde el repositorio de Mark Text en GitHub y se copia a la carpeta `/usr/local/share/icons` (se crea si no existe)

## Configurar un *lanzador*

Las aplicaciones en formato `AppImage` son portables entre distribuciones de Linux, pero también evita que las aplicaciones se integren con los lanzadores de los entornos de escritorio.

Una solución es instalar [AppImageLauncher](https://appimage.github.io/launcher/), aunque requiere la instalación de una aplicación adicional.

Otra opción es la de realizar la configuración de un *launcher* manualmente. Un *launcher* no es más que un fichero de texto que indica al sistema cómo debe ejecutar la aplicación. Podemos usar un fichero de referencia (los *launchers* se encuentran en `/usr/share/application/*.desktop`).

```ini
    cat << EOF > temp/marktext.desktop 
[Desktop Entry]
Name=Mark Text
Comment=Edit markdown files.
GenericName=Markdown Text Editor
Exec=/usr/local/bin/marktext.AppImage --new-window
Icon=/usr/local/share/icons/marktext.png
Type=Application
StartupNotify=false
StartupWMClass=Code
Categories=Utility;TextEditor;Development;
MimeType=text/plain;text/markdown
Actions=new-empty-window;
Keywords=marktext;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=/usr/local/bin/marktext.AppImage --new-window %F
Icon=/usr/local/share/icons/marktext.png
EOF
```
