#
# script no terminado


#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los diferentes modelos de ciberseguridad en Ollama para Debian
#
# Ejecución remota (Puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Modelos/Ollama-Modelos-Ciberseguridad-Instalar.sh | bash
#
# Ejecución remota como root (Para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Modelos/Ollama-Modelos-ciberseguridad-Instalar.sh | sed 's-sudo--g' | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si Ollama está instalado
  vVersOllamaInstalada=$(ollama -v  2> /dev/null | cut -d' ' -f4)
  if [[ $vVersOllamaInstalada == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El binario de ollama no parece estar instalado en el sistema. Abortando script...${cFinColor}"
    echo ""
    exit 1
  fi

# Definir carpetas donde buscar modelos
  aCarpetasPosiblesDeModelos=(
    "$HOME/.ollama/models/blobs"
    "/usr/share/ollama/.ollama/models/blobs"
    "/usr/share/ollama/models/blobs"
    "/opt/ollama/models/blobs"
    "/var/lib/ollama/models/blobs"
  )

# Crear una función para determinar cuál es la carpeta donde se instalan los modelos de Ollama
  fBuscarCarpetaDeModelos() {
    for vRuta in "${aCarpetasPosiblesDeModelos[@]}"; do
      if [ -d "$vRuta" ]; then
        echo "$vRuta"
        return 0
      fi
    done
    echo ""
    return 1
}

# Guardar en una variable la ruta de la carpeta donde se instalan los modelos
  vRutaACarpetaDeModelos=$(fBuscarCarpetaDeModelos)
  if [ $? -eq 0 ]; then
    vCarpetaDeModelos="$vRutaACarpetaDeModelos/"
  else
    #vCarpetaDeModelos="/tmp/"
    echo ""
    echo -e "${cColorRojo}  No se ha encontrado la carpeta donde se instalan los modelos de Ollama.${cFinColor}"
    echo ""
    echo -e "${cColorRojo}  Se comprobó la posible existencia de las siguientes carpetas:${cFinColor}"
    echo ""
    for vCarpeta in "${aCarpetasPosiblesDeModelos[@]}"; do
      echo -e "${cColorRojo}    $vCarpeta/ ${cFinColor}"
    done
    echo ""
    echo -e "${cColorRojo}  Abortando script...${cFinColor}"
    echo ""
    exit 1
  fi

# Función para calcular el espacio libre disponible
  fCalcularEspacioLibreEnCarpetaDeModelos() {
    local vGBsNecesarios="$1"
    # Verificar que la variable global vCarpetaDeModelos esté definida
      if [ -z "$vCarpetaDeModelos" ] || [ -z "$vGBsNecesarios" ]; then
        false
        return
      fi
    # Convertir GB necesarios a KB (1 GiB = 1024 * 1024 KB)
      local vEspacioNecesarioEnKB
      vEspacioNecesarioEnKB=$(echo "$vGBsNecesarios * 1024 * 1024" | bc | cut -d'.' -f1)
    # Obtener espacio libre en KB de la partición correspondiente a la ruta
      local vEspacioLibreEnKB
      vEspacioLibreEnKB=$(df -k "$vCarpetaDeModelos" | tail -1 | tr -s ' ' | cut -d ' ' -f 4)
    # Comparar y retornar true o false
      [ "$vEspacioLibreEnKB" -ge "$vEspacioNecesarioEnKB" ] && true || false
  }

# Indicar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modelos LLM de ciberseguridad para Ollama...${cFinColor}"
  echo ""

# Crear el menú
  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --checklist "Marca los modelos que quieras instalar:" 22 80 16)
    opciones=(

      1 "ciberseguridad saki007ster/CybersecurityRiskAnalyst ( 4,8 GB en disco) ( 0,0 GB en RAM/VRAM)" off

      2 "lazarevtill/Llama-3-WhiteRabbitNeo-8B-v2.0:q4_0  ( 5,1 GB en disco) ( 0,0 GB en RAM/VRAM)" off
      3 "lazarevtill/Llama-3-WhiteRabbitNeo-8B-v2.0       (16,1 GB en disco) ( 0,0 GB en RAM/VRAM)" off

      4 "lazarevtill/WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B:4b-it-q4_K_M ( 5,3 GB en disco) ( 0,0 GB en RAM/VRAM)" off
      5 "lazarevtill/WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B:fp16         (15,1 GB en disco) ( 0,0 GB en RAM/VRAM)" off

      6 "qingmian/Qwen2.5-14B-CyberSecurity            (29,1 GB en disco) ( 0,0 GB en RAM/VRAM)" off

      7 "kala185/CyberKiller:0.1                       ( 2,1 GB en disco) ( 0,0 GB en RAM/VRAM)" off

      8 "csalab/csai                                   ( 4,2 GB en disco) ( 0,0 GB en RAM/VRAM)" off

      9 " pull kangali/room-coder                      ( 4,8 GB en disco) ( 0,0 GB en RAM/VRAM)" off

     10 "kangali/room-research                         ( 4,2 GB en disco) ( 0,0 GB en RAM/VRAM)" off

     11 "ALIENTELLIGENCE/cybersecuritymonitoring       (4,8 GB en disco) (0,0 GB en RAM/VRAM)" off
     12 "ALIENTELLIGENCE/cyberaisecurity               (4,8 GB en disco) (0,0 GB en RAM/VRAM)" off
     13 "ALIENTELLIGENCE/cyberaisecurityv2             (4,8 GB en disco) (0,0 GB en RAM/VRAM)" off
     14 "ALIENTELLIGENCE/cybersecuritythreatanalysis   (4,8 GB en disco) (0,0 GB en RAM/VRAM)" off
     15 "ALIENTELLIGENCE/cybersecuritythreatanalysisv2 (4,8 GB en disco) (0,0 GB en RAM/VRAM)" off
     16 "ALIENTELLIGENCE/streamingdefenselevel3        (4,8 GB en disco) (0,0 GB en RAM/VRAM)" off

    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando x..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=0

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                  ollama pull x
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          2)

            echo ""
            echo "  Instalando x..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=0

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                  ollama pull x
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          3)

            echo ""
            echo "  Instalando x..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=0

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                  ollama pull x
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          4)

            echo ""
            echo "  Instalando x..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=0

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                  ollama pull x
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          5)

            echo ""
            echo "  Instalando x..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=0

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                  ollama pull x
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          6)

            echo ""
            echo "  Instalando x..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=0

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                  ollama pull x
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          7)

            echo ""
            echo "  Instalando x..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=0

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                  ollama pull x
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          8)

            echo ""
            echo "  Instalando x..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=0

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                  ollama pull x
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          9)

            echo ""
            echo "  Instalando x..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=0

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                  ollama pull x
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         10)

            echo ""
            echo "  Instalando x..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=0

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                  ollama pull x
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         11)

            echo ""
            echo "  Instalando x..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=0

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                  ollama pull x
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         12)

            echo ""
            echo "  Instalando x..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=0

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                  ollama pull x
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

      esac

  done
