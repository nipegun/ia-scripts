#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Whisper CPP (de Georgi Gerganov) en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/main/SoftInst/ParaCLI/IA-OpenAIWhisper-InstalarYConfigurar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/main/SoftInst/ParaCLI/IA-OpenAIWhisper-InstalarYConfigurar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Whisper CPP (de Georgi Gerganov) para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Whisper CPP (de Georgi Gerganov) para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Marca como quieres instalar la herramienta:" 22 70 16)
        opciones=(
          1 "Clonar el repo de WhisperCPP"                                 on
          2 "  Crear el entorno virtual de python e instalar dentro"          on
          3 "    Compilar e instalar en /home/$USER/bin/"                     off
          4 "  Instalar en /home/$USER/.local/bin/"                           off
          5 "    Agregar /home/$USER/.local/bin/ al path"                     off
          6 "Clonar repo, crear venv, compilar e instalar a nivel de sistema" off
          7 "Otro tipo de instalación"                                        off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Clonando el repo..."
              echo ""

              # Clonar el repo
                mkdir -p ~/repos/cpp/
                cd ~/repos/cpp/
                rm -rf ~/repos/cpp/whisper.cpp/
                # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install git
                    echo ""
                  fi
                git clone https://github.com/ggerganov/whisper.cpp

            ;;

            2)

              echo ""
              echo "    Compilando..."
              echo ""

              cd ~/repos/cpp/whisper.cpp/
              # Instalar paquetes necesarios
                sudo apt-get -y install libsdl2-dev
                sudo apt-get -y install build-essential
                sudo apt-get -y install portaudio19-dev
                # En el caso de necesitar correr los scripts .py de whisper.cpp
                  # sudo apt-get install python3
                  # sudo apt-get install python3-pip
              make


    Esto creará varios binarios en la carpeta principal, por ejemplo main, main-q5, etc.




./main -m models/ggml-base.bin -f ruta/a/tu_audio.wav
              


              
              # Notificar fin de instalación en el entorno virtual
                echo ""
                echo -e "${cColorVerde}    Entorno virtual preparado. Whisper se puede ejecutar desde el venv de la siguiente forma:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      source ~/repos/python/whisper/venv/bin/activate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        whisper mi_video.mp4 --model medium   --language Spanish ${cFinColor}"
                echo -e "${cColorVerde}        whisper mi_video.vob --model large-v2 --language Spanish ${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      deactivate${cFinColor}"
                echo ""

            ;;

            3)

              echo ""
              echo "      Descargando el modelo large-v3..."
              echo ""
              echo ""
              echo "        Se ha descargado el modelo large-v3, aunque también hay otros modelos disponibles:"
              echo ""
              echo "          tiny"
              echo "            tiny.en"
              echo "            tiny-q5_1"
              echo "            tiny.en-q5_1"
              echo "            tiny-q8_0"
              echo "          base"
              echo "            base.en"
              echo "            base-q5_1"
              echo "            base.en-q5_1"
              echo "            base-q8_0"
              echo "          small"
              echo "            small.en"
              echo "            small.en-tdrz"
              echo "            small-q5_1"
              echo "            small.en-q5_1"
              echo "            small-q8_0"
              echo "          medium"
              echo "            medium.en"
              echo "            medium-q5_0"
              echo "            medium.en-q5_0"
              echo "            medium-q8_0"
              echo "          large-v1"
              echo "          large-v2"
              echo "            large-v2-q5_0"
              echo "            large-v2-q8_0"
              echo "          large-v3"
              echo "            large-v3-q5_0"
              echo "            large-v3-turbo"
              echo "            large-v3-turbo-q5_0"
              echo "            large-v3-turbo-q8_0"

              cd ~/repos/cpp/whisper.cpp/
              ./models/download-ggml-model.sh base

Con esto descargarás un archivo de modelo (p.ej. ggml-base.bin) a la carpeta models/.

Ejecuta el binario para transcribir un archivo de audio:

              # Notificar fin de ejecución del script
                echo ""
                echo "  El script ha finalizado. whisper se ha descargado, compilado e instalado."
                echo ""
                echo "    Puedes encontrar el binario en ~/bin/whisper"
                echo ""
                echo "  El binario debe ser usado con precaución. Es mejor correr el script directamente con python, de la siguiente manera:"
                echo ""
                echo "    source ~/PythonVirtualEnvironments/whisper/bin/activate"
                echo "    python3 ~/scripts/python/whisper/whisper.py [Argumentos]"
                echo "    deactivate"
                echo ""

            ;;

            4)

              echo ""
              echo "  Instalando en /home/$USER/.local/bin/..."
              echo ""

              # Comprobar si el paquete python3-setuptools está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s python3-setuptools 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete python3-setuptools no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install python3-setuptools
                  echo ""
                fi
              cd ~/repos/python/analyzeMFT/
              python3 setup.py install --user
              cd ~

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    Para ejecutar analyzeMFT instalado en /home/$USER/.local/bin/:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Si al instalar has marcado 'Agregar /home/$USER/.local/bin/ al path', simplemente ejecuta:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        analyzemft [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Si al instalar NO has marcado 'Agregar /home/$USER/.local/bin/ al path', ejecuta:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}       ~/.local/bin/analyzemft [Parámetros]${cFinColor}"
                echo ""

            ;;

            5)

              echo ""
              echo "  Agregando /home/$USER/.local/bin al path..."
              echo ""
              echo 'export PATH=/home/'"$USER"'/.local/bin:$PATH' >> ~/.bashrc

            ;;

            6)

              echo ""
              echo "  Clonando repo, creando venv, compilando e instalando a nivel de sistema..."
              echo ""

              # Instalar paquetes necesarios
                echo ""
                echo "    Instalando paquetes necesarios..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install python3-pip
                sudo apt-get -y install python3-setuptools
                sudo apt-get -y install python3-dev
                sudo apt-get -y install python3-venv
                sudo apt-get -y install build-essential
                sudo apt-get -y install liblzma-dev

              # Preparar el entorno virtual de python
                echo ""
                echo "    Preparando el entorno virtual de python..."
                echo ""
                mkdir -p /tmp/PythonVirtualEnvironments/ 2> /dev/null
                cd /tmp/PythonVirtualEnvironments/
                rm -rf /tmp/PythonVirtualEnvironments/analyzeMFT/
                python3 -m venv analyzeMFT

              # Ingresar en el entorno virtual e instalar
                echo ""
                echo "    Ingresando en el entorno virtual e instalando..."
                echo ""
                source /tmp/PythonVirtualEnvironments/analyzeMFT/bin/activate

              # Clonar el repo
                echo ""
                echo "  Clonando el repo..."
                echo ""
                cd /tmp/PythonVirtualEnvironments/analyzeMFT/
                git clone https://github.com/rowingdude/analyzeMFT.git
                mv analyzeMFT code

              # Compilar
                echo ""
                echo "    Compilando..."
                echo ""
                cd code
                python3 -m pip install -r requirements.txt
                python3 -m pip install -r requirements-dev.txt
                python3 -m pip install wheel
                python3 -m pip install setuptools
                python3 -m pip install pyinstaller
                pyinstaller --onefile --hidden-import=importlib.metadata --collect-all=analyzeMFT analyzeMFT.py

              # Desactivar el entorno virtual
                echo ""
                echo "    Desactivando el entorno virtual..."
                echo ""
                deactivate

              # Copiar los binarios compilados a la carpeta de binarios del usuario
                echo ""
                echo "    Copiando los binarios a la carpeta /usr/bin/"
                echo ""
                sudo rm -f /usr/bin/analyzeMFT
                sudo cp -vf /tmp/PythonVirtualEnvironments/analyzeMFT/code/dist/analyzeMFT /usr/bin/analyzeMFT
                cd ~

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    La instalación ha finalizado. Se han copiado las herramientas a /usr/bin/ ${cFinColor}"
                echo -e "${cColorVerde}    Puedes ejecutarlas de la siguiente forma: ${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      analyzeMFT [Parámetros]${cFinColor}"
                echo ""

            ;;

            7)

              echo ""
              echo "  Otro tipo de instalación (Pruebas)..."
              echo ""

            ;;


        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Whisper CPP (de Georgi Gerganov) para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Whisper CPP (de Georgi Gerganov) para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Whisper CPP (de Georgi Gerganov) para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Whisper CPP (de Georgi Gerganov) para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Whisper CPP (de Georgi Gerganov) para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
