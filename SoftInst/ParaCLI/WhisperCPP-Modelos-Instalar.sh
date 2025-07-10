#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar modelos de whisper para whisper.cpp en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/WhisperCPP-Modelos-Instalar.sh | bash
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/WhisperCPP-Modelos-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/WhisperCPP-Modelos-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar que el script para descargar modelos está instalado
  if [[ ! -f ~/repos/cpp/whisper.cpp/models/download-ggml-model.sh ]]; then
    echo -e "${cColorRojo}  El script para descargar modelos no está disponible.${cFinColor}"
    echo -e "${cColorRojo}  Probablemente no hayas descargado, compilado e instalado whisper.cpp.${cFinColor}"
    echo ""
    echo -e "${cColorRojo}  Para instalarlo, ejecuta como usuario con permisos sudo:${cFinColor}"
    echo ""
    echo -e "${cColorRojo}    curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCli/WhisperCPP-DescargarCompilarEInstalar.sh | bash${cFinColor}"
    echo ""
    echo -e "${cColorRojo}  O, si sólo tienes el usuario root:${cFinColor}"
    echo ""
    echo -e "${cColorRojo}    curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCli/WhisperCPP-DescargarCompilarEInstalar.sh | sed 's-sudo--g' | bash${cFinColor}"
    exit 1
  fi

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
  menu=(dialog --checklist "Marca los modelos de whisper que quieras instalar:" 22 96 16)
    opciones=(
      1 "tiny                (x GB de Espacio, x GB de RAM/VRAM)" off
      2 "tiny.en             (x GB de Espacio, x GB de RAM/VRAM)" off
      3 "tiny-q5_1           (x GB de Espacio, x GB de RAM/VRAM)" off
      4 "tiny.en-q5_1        (x GB de Espacio, x GB de RAM/VRAM)" off
      5 "tiny-q8_0           (x GB de Espacio, x GB de RAM/VRAM)" off
      6 "base                (x GB de Espacio, x GB de RAM/VRAM)" off
      7 "base.en             (x GB de Espacio, x GB de RAM/VRAM)" off
      8 "base-q5_1           (x GB de Espacio, x GB de RAM/VRAM)" off
      9 "base.en-q5_1        (x GB de Espacio, x GB de RAM/VRAM)" off
     10 "base-q8_0           (x GB de Espacio, x GB de RAM/VRAM)" off
     11 "small               (x GB de Espacio, x GB de RAM/VRAM)" off
     12 "small.en            (x GB de Espacio, x GB de RAM/VRAM)" off
     13 "small.en-tdrz       (x GB de Espacio, x GB de RAM/VRAM)" off
     14 "small-q5_1          (x GB de Espacio, x GB de RAM/VRAM)" off
     15 "small.en-q5_1       (x GB de Espacio, x GB de RAM/VRAM)" off
     16 "small-q8_0          (x GB de Espacio, x GB de RAM/VRAM)" off
     17 "medium              (x GB de Espacio, x GB de RAM/VRAM)" off
     18 "medium.en           (x GB de Espacio, x GB de RAM/VRAM)" off
     19 "medium-q5_0         (x GB de Espacio, x GB de RAM/VRAM)" off
     20 "medium.en-q5_0      (x GB de Espacio, x GB de RAM/VRAM)" off
     21 "medium-q8_0         (x GB de Espacio, x GB de RAM/VRAM)" off
     22 "large-v1            (x GB de Espacio, x GB de RAM/VRAM)" off
     23 "large-v2            (x GB de Espacio, x GB de RAM/VRAM)" off
     24 "large-v2-q5_0       (x GB de Espacio, x GB de RAM/VRAM)" off
     25 "large-v2-q8_0       (x GB de Espacio, x GB de RAM/VRAM)" off
     26 "large-v3            (x GB de Espacio, x GB de RAM/VRAM)" off
     27 "large-v3-q5_0       (x GB de Espacio, x GB de RAM/VRAM)" off
     28 "large-v3-turbo      (x GB de Espacio, x GB de RAM/VRAM)" off
     29 "large-v3-turbo-q5_0 (x GB de Espacio, x GB de RAM/VRAM)" off
     30 "large-v3-turbo-q8_0 (x GB de Espacio, x GB de RAM/VRAM)" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Instalando el modelo tiny..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh tiny && echo -e "${cColorVerde}\n    Modelo tiny, instalado. \n${cFinColor}"

        ;;

        2)

          echo ""
          echo "  Instalando el modelo tiny.en..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh tiny.en && echo -e "${cColorVerde}\n    Modelo tiny.en, instalado. \n${cFinColor}"

        ;;

        3)

          echo ""
          echo "  Instalando el modelo tiny-q5_1..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh tiny-q5_1 && echo -e "${cColorVerde}\n    Modelo tiny-q5_1, instalado. \n${cFinColor}"

        ;;

        4)

          echo ""
          echo "  Instalando el modelo tiny.en-q5_1..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh tiny.en-q5_1 && echo -e "${cColorVerde}\n    Modelo tiny.en-q5_1, instalado. \n${cFinColor}"

        ;;

        5)

          echo ""
          echo "  Instalando el modelo tiny-q8_0..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh tiny-q8_0 && echo -e "${cColorVerde}\n    Modelo tiny-q8_0, instalado. \n${cFinColor}"

        ;;

        6)

          echo ""
          echo "  Instalando el modelo base..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh base && echo -e "${cColorVerde}\n    Modelo base, instalado. \n${cFinColor}"

        ;;

        7)

          echo ""
          echo "  Instalando el modelo base.en..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh base.en && echo -e "${cColorVerde}\n    Modelo base.en, instalado. \n${cFinColor}"

        ;;

        8)

          echo ""
          echo "  Instalando el modelo base-q5_1..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh base-q5_1 && echo -e "${cColorVerde}\n    Modelo base-q5_1, instalado. \n${cFinColor}"

        ;;

        9)

          echo ""
          echo "  Instalando el modelo base.en-q5_1..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh base.en-q5_1 && echo -e "${cColorVerde}\n    Modelo base.en-q5_1, instalado. \n${cFinColor}"

        ;;

        10)

          echo ""
          echo "  Instalando el modelo base-q8_0..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh base-q8_0 && echo -e "${cColorVerde}\n    Modelo base-q8_0, instalado. \n${cFinColor}"

        ;;

        11)

          echo ""
          echo "  Instalando el modelo small..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh small && echo -e "${cColorVerde}\n    Modelo small, instalado. \n${cFinColor}"

        ;;

        12)

          echo ""
          echo "  Instalando el modelo small.en..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh small.en && echo -e "${cColorVerde}\n    Modelo small.en, instalado. \n${cFinColor}"

        ;;

        13)

          echo ""
          echo "  Instalando el modelo small.en-tdrz..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh small.en-tdrz && echo -e "${cColorVerde}\n    Modelo small.en-tdrz, instalado. \n${cFinColor}"

        ;;

        14)

          echo ""
          echo "  Instalando el modelo small-q5_1..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh small-q5_1 && echo -e "${cColorVerde}\n    Modelo small-q5_1, instalado. \n${cFinColor}"

        ;;

        15)

          echo ""
          echo "  Instalando el modelo small.en-q5_1..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh small.en-q5_1 && echo -e "${cColorVerde}\n    Modelo small.en-q5_1, instalado. \n${cFinColor}"

        ;;

        16)

          echo ""
          echo "  Instalando el modelo small-q8_0..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh small-q8_0 && echo -e "${cColorVerde}\n    Modelo small-q8_0, instalado. \n${cFinColor}"

        ;;

        17)

          echo ""
          echo "  Instalando el modelo medium..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh medium && echo -e "${cColorVerde}\n    Modelo medium, instalado. \n${cFinColor}"

        ;;

        18)

          echo ""
          echo "  Instalando el modelo medium.en..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh medium.en && echo -e "${cColorVerde}\n    Modelo medium.en, instalado. \n${cFinColor}"

        ;;

        19)

          echo ""
          echo "  Instalando el modelo medium-q5_0..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh medium-q5_0 && echo -e "${cColorVerde}\n    Modelo medium-q5_0, instalado. \n${cFinColor}"

        ;;

        20)

          echo ""
          echo "  Instalando el modelo medium.en-q5_0..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh medium.en-q5_0 && echo -e "${cColorVerde}\n    Modelo medium.en-q5_0, instalado. \n${cFinColor}"

        ;;

        21)

          echo ""
          echo "  Instalando el modelo medium-q8_0..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh medium-q8_0 && echo -e "${cColorVerde}\n    Modelo medium-q8_0, instalado. \n${cFinColor}"

        ;;

        22)

          echo ""
          echo "  Instalando el modelo large-v1..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v1 && echo -e "${cColorVerde}\n    Modelo large-v1, instalado. \n${cFinColor}"

        ;;

        23)

          echo ""
          echo "  Instalando el modelo large-v2..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v2 && echo -e "${cColorVerde}\n    Modelo large-v2, instalado. \n${cFinColor}"

        ;;

        24)

          echo ""
          echo "  Instalando el modelo large-v2-q5_0..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v2-q5_0 && echo -e "${cColorVerde}\n    Modelo large-v2-q5_0, instalado. \n${cFinColor}"

        ;;

        25)

          echo ""
          echo "  Instalando el modelo large-v2-q8_0..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v2-q8_0 && echo -e "${cColorVerde}\n    Modelo large-v2-q8_0, instalado. \n${cFinColor}"

        ;;

        26)

          echo ""
          echo "  Instalando el modelo large-v3..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v3 && echo -e "${cColorVerde}\n    Modelo large-v3, instalado. \n${cFinColor}"

        ;;

        27)

          echo ""
          echo "  Instalando el modelo large-v3-q5_0..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v3-q5_0 && echo -e "${cColorVerde}\n    Modelo large-v3-q5_0, instalado. \n${cFinColor}"

        ;;

        28)

          echo ""
          echo "  Instalando el modelo large-v3-turbo..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v3-turbo && echo -e "${cColorVerde}\n    Modelo large-v3-turbo, instalado. \n${cFinColor}"

        ;;

        29)

          echo ""
          echo "  Instalando el modelo large-v3-turbo-q5_0..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v3-turbo-q5_0 && echo -e "${cColorVerde}\n    Modelo large-v3-turbo-q5_0, instalado. \n${cFinColor}"

        ;;

        30)

          echo ""
          echo "  Instalando el modelo large-v3-turbo-q8_0..."
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v3-turbo-q8_0 && echo -e "${cColorVerde}\n    Modelo large-v3-turbo-q8_0, instalado. \n${cFinColor}"

        ;;

    esac

done

