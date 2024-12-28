#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar modelos de whisper para whisper.cpp en Debian
#
# Ejecución remota con sudo:
#   curl -sL x | sudo bash
#
# Ejecución remota como root:
#   curl -sL x | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' x | bash
#
# Ejecución remota con parámetros:
#   curl -sL x | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL x | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Crear el menú
  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install dialog
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
          echo "  Instalando el modelo tiny"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh tiny

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo tiny, instalado.${cFinColor}"
            echo ""

        ;;

        2)

          echo ""
          echo "  Instalando el modelo tiny.en"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh tiny.en

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo tiny.en, instalado.${cFinColor}"
            echo ""

        ;;

        3)

          echo ""
          echo "  Instalando el modelo tiny-q5_1"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh tiny-q5_1

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo tiny-q5_1, instalado.${cFinColor}"
            echo ""

        ;;

        4)

          echo ""
          echo "  Instalando el modelo tiny.en-q5_1"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh tiny.en-q5_1

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo tiny.en-q5_1, instalado.${cFinColor}"
            echo ""

        ;;

        5)

          echo ""
          echo "  Instalando el modelo tiny-q8_0"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh tiny-q8_0

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo tiny-q8_0, instalado.${cFinColor}"
            echo ""

        ;;

        6)

          echo ""
          echo "  Instalando el modelo base"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh base

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo base, instalado.${cFinColor}"
            echo ""

        ;;

        7)

          echo ""
          echo "  Instalando el modelo base.en"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh base.en

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo base.en, instalado.${cFinColor}"
            echo ""

        ;;

        8)

          echo ""
          echo "  Instalando el modelo base-q5_1"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh base-q5_1

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo base-q5_1, instalado.${cFinColor}"
            echo ""

        ;;

        9)

          echo ""
          echo "  Instalando el modelo base.en-q5_1"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh base.en-q5_1

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo base.en-q5_1, instalado.${cFinColor}"
            echo ""

        ;;

        10)

          echo ""
          echo "  Instalando el modelo base-q8_0"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh base-q8_0

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo base-q8_0, instalado.${cFinColor}"
            echo ""

        ;;

        11)

          echo ""
          echo "  Instalando el modelo small"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh small

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo small, instalado.${cFinColor}"
            echo ""

        ;;

        12)

          echo ""
          echo "  Instalando el modelo small.en"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh small.en

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo small.en, instalado.${cFinColor}"
            echo ""

        ;;

        13)

          echo ""
          echo "  Instalando el modelo small.en-tdrz"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh small.en-tdrz

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo small.en-tdrz, instalado.${cFinColor}"
            echo ""

        ;;

        14)

          echo ""
          echo "  Instalando el modelo small-q5_1"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh small-q5_1

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo small-q5_1, instalado.${cFinColor}"
            echo ""

        ;;

        15)

          echo ""
          echo "  Instalando el modelo small.en-q5_1"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh small.en-q5_1

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo small.en-q5_1, instalado.${cFinColor}"
            echo ""

        ;;

        16)

          echo ""
          echo "  Instalando el modelo small-q8_0"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh small-q8_0

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo small-q8_0, instalado.${cFinColor}"
            echo ""

        ;;

        17)

          echo ""
          echo "  Instalando el modelo medium"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh medium

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo medium, instalado.${cFinColor}"
            echo ""

        ;;

        18)

          echo ""
          echo "  Instalando el modelo medium.en"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh medium.en

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo medium.en, instalado.${cFinColor}"
            echo ""

        ;;

        19)

          echo ""
          echo "  Instalando el modelo medium-q5_0"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh medium-q5_0

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo medium-q5_0, instalado.${cFinColor}"
            echo ""

        ;;

        20)

          echo ""
          echo "  Instalando el modelo medium.en-q5_0"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh medium.en-q5_0

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo medium.en-q5_0, instalado.${cFinColor}"
            echo ""

        ;;

        21)

          echo ""
          echo "  Instalando el modelo medium-q8_0"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh medium-q8_0

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo medium-q8_0, instalado.${cFinColor}"
            echo ""

        ;;

        22)

          echo ""
          echo "  Instalando el modelo large-v1"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v1

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo large-v1, instalado.${cFinColor}"
            echo ""

        ;;

        23)

          echo ""
          echo "  Instalando el modelo large-v2"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v2

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo large-v2, instalado.${cFinColor}"
            echo ""

        ;;

        24)

          echo ""
          echo "  Instalando el modelo large-v2-q5_0"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v2-q5_0

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo large-v2-q5_0, instalado.${cFinColor}"
            echo ""

        ;;

        25)

          echo ""
          echo "  Instalando el modelo large-v2-q8_0"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v2-q8_0

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo large-v2-q8_0, instalado.${cFinColor}"
            echo ""

        ;;

        26)

          echo ""
          echo "  Instalando el modelo large-v3"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v3

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo large-v3, instalado.${cFinColor}"
            echo ""

        ;;

        27)

          echo ""
          echo "  Instalando el modelo large-v3-q5_0"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v3-q5_0

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo large-v3-q5_0, instalado.${cFinColor}"
            echo ""

        ;;

        28)

          echo ""
          echo "  Instalando el modelo large-v3-turbo"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v3-turbo

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo large-v3-turbo, instalado.${cFinColor}"
            echo ""

        ;;

        29)

          echo ""
          echo "  Instalando el modelo large-v3-turbo-q5_0"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v3-turbo-q5_0

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo large-v3-turbo-q5_0, instalado.${cFinColor}"
            echo ""

        ;;

        30)

          echo ""
          echo "  Instalando el modelo large-v3-turbo-q8_0"
          echo ""
          # Posicionarse en la carpeta:
            cd ~/repos/cpp/whisper.cpp/
          # Descargar
            ./models/download-ggml-model.sh large-v3-turbo-q8_0

          # Notificar fin de la instalación del modelo
            echo ""
            echo -e "${cColorVerde}    Modelo large-v3-turbo-q8_0, instalado.${cFinColor}"
            echo ""

        ;;

    esac

done

