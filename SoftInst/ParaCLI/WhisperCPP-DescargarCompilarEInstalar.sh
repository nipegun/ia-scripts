#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Whisper CPP (de Georgi Gerganov) en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCli/WhisperCPP-DescargarCompilarEInstalar.sh | bash
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCli/WhisperCPP-DescargarCompilarEInstalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCli/WhisperCPP-DescargarCompilarEInstalar.sh | nano -
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
          1 "Clonar el repo de WhisperCPP"                                      on
          2 "Preparar para compilar"                                            on
          3 "  Compilar para uso únicamente con CPU x86"                        off
          4 "  Compilar para uso con CPU x86 y tarjeta nVidia con soporte CUDA" off
          5 "  Compilar para uso con CPU ARM de 32 bits"                        off
          6 "  Compilar para uso con CPU ARM de 64 bits"                        off
          7 "  Compilar para WebAssembly"                                       off
          8 "    Copiar binarios a ~/.local/bin/ "                              on
          9 "  Instalar modelos "                                               off
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
              echo "  Preparar para compilar..."
              echo ""
              
              # Instalar paquetes necesarios
                sudo apt-get -y install libsdl2-dev
                sudo apt-get -y install build-essential
                sudo apt-get -y install portaudio19-dev
                sudo apt-get -y install cmake
                # BLAS / OpenBLAS
                  sudo apt-get -y install libopenblas-dev
                # Para poder correr los scripts .py de whisper.cpp
                  sudo apt-get -y install python3
                  sudo apt-get -y install python3-pip

            ;;

            3)

              echo ""
              echo "    Compilando para uso únicamente con CPU x86..."
              echo ""
              # Posicionarse en la carpeta
                cd ~/repos/cpp/whisper.cpp/
              # Compilar
                make clean
                make CFLAGS="-O3 -march=native"

              # Notificar fin de la compilación
                echo ""
                echo -e "${cColorVerde}    Compilación para uso con CPU x86, finalizada. Los binarios están en:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      ~/repos/cpp/whisper.cpp/build/bin/${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Para hacer el reconocimiento del habla sobre un archivo .wav PCM lineal 16 bits 16 kHz (el único soportado):${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        ~/repos/cpp/whisper.cpp/build/bin/whisper-cli --language es --output-srt --model /Ruta/Al/modelo.bin --file /Ruta/Al/Archivo.wav${cFinColor}"
                echo ""
                echo ""
                echo -e "${cColorVerde}      Si el archivo no es .wav o no es un .wav con formato soportado se puede, o bien convertir el archivo a un formato soportado:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        ffmpeg -i /Ruta/Al/ArchivoDeEntrada.mp3 -ar 16000 -ac 1 -c:a pcm_s16le /Ruta/Al/ArchivoDeSalida.wav${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        para luego ejecutar con:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}          ~/repos/cpp/whisper.cpp/build/bin/whisper-cli --language es --output-srt --model /Ruta/Al/modelo.bin --file /Ruta/Al/ArchivoDeSalida.wav${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      ...o bien pipear la salida de una conversión de audio hacia whisper:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        ffmpeg -i /Ruta/Al/ArchivoDeEntrada.mp3 -ar 16000 -ac 1 -c:a pcm_s16le -f wav - | ~/repos/cpp/whisper.cpp/build/bin/whisper-cli --language es --output-srt --model /Ruta/Al/modelo.bin -f -${cFinColor}"
                echo ""


            ;;

            4)

              echo ""
              echo "    Compilando para uso con CPU x86 y tarjeta nVidia con soporte CUDA..."
              echo ""
              # Instalar el CUDA toolkit
                sudo apt-get -y install nvidia-cuda-toolkit
              # Posicionarse en la carpeta
                cd ~/repos/cpp/whisper.cpp/
              # Compilar
                make clean
                make cublas=1 CFLAGS="-O3 -march=native"

              # Notificar fin de la compilación
                echo ""
                echo -e "${cColorVerde}    Compilación para uso con CPU x86 y tarjeta nVidia con CUDA, finalizada. Los binarios están en:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      ~/repos/cpp/whisper.cpp/build/bin/${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Para hacer el reconocimiento del habla sobre un archivo .wav PCM lineal 16 bits 16 kHz (el único soportado):${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        ~/repos/cpp/whisper.cpp/build/bin/whisper-cli --gpu-layers 10 --language es --output-srt --model /Ruta/Al/modelo.bin --file /Ruta/Al/Archivo.wav${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Ajusta las capas a cargar en VRAM, dependiendo de la cantidad de VRAM que tengas.${cFinColor}"
                echo ""
                echo ""
                echo -e "${cColorVerde}      Si el archivo no es .wav o no es un .wav con formato soportado se puede, o bien convertir el archivo a un formato soportado:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        ffmpeg -i /Ruta/Al/ArchivoDeEntrada.mp3 -ar 16000 -ac 1 -c:a pcm_s16le /Ruta/Al/ArchivoDeSalida.wav${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        para luego ejecutar con:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}          ~/repos/cpp/whisper.cpp/build/bin/whisper-cli --gpu-layers 10 --language es --output-srt --model /Ruta/Al/modelo.bin --file /Ruta/Al/ArchivoDeSalida.wav${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      ...o bien pipear la salida de una conversión de audio hacia whisper:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        ffmpeg -i /Ruta/Al/ArchivoDeEntrada.mp3 -ar 16000 -ac 1 -c:a pcm_s16le -f wav - | ~/repos/cpp/whisper.cpp/build/bin/whisper-cli --gpu-layers 10 --language es --output-srt --model /Ruta/Al/modelo.bin -f -${cFinColor}"
                echo ""

            ;;

            5)

              echo ""
              echo "    Compilando para uso con CPU ARM de 32 bits..."
              echo ""
              # Instalar el toolchain
                sudo apt-get -y install arm-linux-gnueabihf-gcc
              # Posicionarse en la carpeta
                cd ~/repos/cpp/whisper.cpp/
              # Compilar
                make clean
                make CC=arm-linux-gnueabihf-gcc CFLAGS="-O3 -march=armv7-a -mfpu=neon -mfloat-abi=hard"

              # Notificar fin de la compilación
                echo ""
                echo -e "${cColorVerde}    Compilación para uso con CPU ARM de 32 bits, finalizada. Los binarios están en:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      ~/repos/cpp/whisper.cpp/build/bin/${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Para ejecutarlos, muévelos a un sistema con procesador ARM de 32 bits${cFinColor}"
                echo ""

            ;;

            6)

              echo ""
              echo "    Compilando para uso con CPU ARM de 64 bits..."
              echo ""
              # Instalar el toolchain
                sudo apt-get -y install gcc-aarch64-linux-gnu
              # Posicionarse en la carpeta
                cd ~/repos/cpp/whisper.cpp/
              # Compilar
                make clean
                make CC=aarch64-linux-gnu-gcc CFLAGS="-O3 -march=armv8-a"

              # Notificar fin de la compilación
                echo ""
                echo -e "${cColorVerde}    Compilación para uso con CPU ARM de 64 bits, finalizada. Los binarios están en:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      ~/repos/cpp/whisper.cpp/build/bin/${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Para ejecutarlos, muévelos a un sistema con procesador ARM de 64 bits${cFinColor}"
                echo ""

            ;;

            7)

              echo ""
              echo "    Compilando para WebAssembly (wasm)..."
              echo ""
              # Posicionarse en la carpeta
                cd ~/repos/cpp/whisper.cpp/
              # Compilar
                make clean
                make wasm=1

              # Notificar fin de la compilación
                echo ""
                echo -e "${cColorVerde}    Compilación para WebAssembly, finalizada. Los binarios están en:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      ~/repos/cpp/whisper.cpp/build/bin/${cFinColor}"
                echo ""

            ;;

            8)

              echo ""
              echo "      Copiando binarios a ~/.local/bin/..."
              echo ""
              mkdir -p ~/.local/bin/
              cp ~/repos/cpp/whisper.cpp/build/bin/* ~/.local/bin/

              # Notificar fin de la compilación
                echo ""
                echo -e "${cColorVerde}        Binarios copiados a ~/.local/bin/${cFinColor}"
                echo ""
                echo -e "${cColorVerde}          Para hacer el reconocimiento del habla sobre un archivo .wav PCM lineal 16 bits 16 kHz (el único soportado):${cFinColor}"
                echo ""
                echo -e "${cColorVerde}            Usando sólo CPU:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}              whisper-cli --language es --output-srt --model ~/repos/cpp/whisper.cpp/models/ggml-tiny.bin --file /Ruta/Al/Archivo.wav${cFinColor}"
                echo ""
                echo -e "${cColorVerde}            Usando CPU y tarjeta gráfica nVidia con soporte CUDA:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}              whisper-cli --gpu-layers 10 --language es --output-srt --model ~/repos/cpp/whisper.cpp/models/ggml-tiny.bin --file /Ruta/Al/Archivo.wav${cFinColor}"
                echo ""
                echo -e "${cColorVerde}              Ajusta las capas a cargar en VRAM, dependiendo de la cantidad de VRAM que tengas.${cFinColor}"
                echo ""
                echo ""
                echo -e "${cColorVerde}            Si el archivo no es .wav o no es un .wav con formato soportado se puede, o bien convertir el archivo a un formato soportado:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}              ffmpeg -i /Ruta/Al/ArchivoDeEntrada.mp3 -ar 16000 -ac 1 -c:a pcm_s16le /Ruta/Al/ArchivoDeSalida.wav${cFinColor}"
                echo ""
                echo -e "${cColorVerde}              para luego ejecutar con:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}                whisper-cli --language es --output-srt --model /Ruta/Al/modelo.bin --file /Ruta/Al/ArchivoDeSalida.wav${cFinColor}"
                echo ""
                echo -e "${cColorVerde}                  o${cFinColor}"
                echo ""
                echo -e "${cColorVerde}                whisper-cli --gpu-layers 10 --language es --output-srt --model /Ruta/Al/modelo.bin --file /Ruta/Al/ArchivoDeSalida.wav${cFinColor}"
                echo ""
                echo -e "${cColorVerde}            ...o bien pipear la salida de una conversión de audio hacia whisper:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}              ffmpeg -i /Ruta/Al/ArchivoDeEntrada.mp3 -ar 16000 -ac 1 -c:a pcm_s16le -f wav - | whisper-cli --language es --output-srt --model /Ruta/Al/modelo.bin -f -${cFinColor}"
                echo ""
                echo -e "${cColorVerde}                o${cFinColor}"
                echo ""
                echo -e "${cColorVerde}              ffmpeg -i /Ruta/Al/ArchivoDeEntrada.mp3 -ar 16000 -ac 1 -c:a pcm_s16le -f wav - | whisper-cli --gpu-layers 10 --language es --output-srt --model /Ruta/Al/modelo.bin -f -${cFinColor}"
                echo ""

            ;;

            9)

              echo ""
              echo "  Instalando modelos..."
              echo ""
              curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCli/WhisperCPP-InstalarModelos.sh | bash

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
