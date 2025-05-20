#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los diferentes modelos de Gemma en Ollama para Debian
#
# Ejecución remota (Puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCli/Modelos/Ollama-Gemma.sh | bash
#
# Ejecución remota como root (Para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCli/Modelos/Ollama-Gemma.sh | sed 's-sudo--g' | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Crear una función para determinar cuál es la carpeta donde se instalan los modelos de Ollama
  fBuscarCarpetaDeModelos() {
    vRutasPosibles=(
      "$HOME/.ollama/models/blobs"
      "/usr/share/ollama/.ollama/models/blobs"
      "/usr/share/ollama/models/blobs"
      "/opt/ollama/models/blobs"
      "/var/lib/ollama/models/blobs"
    )

    for vRuta in "${vRutasPosibles[@]}"; do
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
    echo "No se ha encontrado la carpeta donde se instalan los modelos de Ollama."
    echo "Se ha buscado en las siguiente ubicaciones:"
    echo "${vRutasPosibles[@]}"
    echo ""
    "  Abortando script..."
    echo ""
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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modelos LLM de Gemma para Ollama...${cFinColor}"
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

      1 "gemma3 1b-it-q4_K_M  ( 0,9 GB en disco) (0,97 GB en RAM/VRAM)" off
      2 "gemma3 1b-it-q8_0    ( 1,2 GB en disco) (x,x GB en RAM/VRAM)" off
      3 "gemma3 1b-it-fp16    ( 2,1 GB en disco) (x,x GB en RAM/VRAM)" off

      4 "gemma3 4b-it-q4_K_M  ( 3,4 GB en disco) (x,x GB en RAM/VRAM)" off
      5 "gemma3 4b-it-q8_0    ( 5,1 GB en disco) (x,x GB en RAM/VRAM)" off
      6 "gemma3 4b-it-fp16    ( 8,7 GB en disco) (x,x GB en RAM/VRAM)" off

      7 "gemma3 12b-it-q4_K_M ( 8,2 GB en disco) (x,x GB en RAM/VRAM)" off
      8 "gemma3 12b-it-q8_0   (13,2 GB en disco) (x,x GB en RAM/VRAM)" off
      9 "gemma3 12b-it-fp16   (24,2 GB en disco) (x,x GB en RAM/VRAM)" off

     10 "gemma3 27b-it-q4_K_M (17,2 GB en disco) (x,x GB en RAM/VRAM)" off
     11 "gemma3 27b-it-q8_0   (29,2 GB en disco) (x,x GB en RAM/VRAM)" off
     12 "gemma3 27b-it-fp16   (54,2 GB en disco) (x,x GB en RAM/VRAM)" off

    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando gemma3:1b-it-q4_K_M..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=0.9

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                  ollama pull gemma3:1b-it-q4_K_M
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma3:1b-it-q4_K_M.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          2)

            echo ""
            echo "  Instalando gemma3:1b-it-q8_0..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=1.2

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                ollama pull gemma3:1b-it-q8_0
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma3:1b-it-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          3)

            echo ""
            echo "  Instalando gemma3:1b-it-fp16..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=2.1

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                ollama pull gemma3:1b-it-fp16
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma3:1b-it-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          4)

            echo ""
            echo "  Instalando gemma3:4b-it-q4_K_M..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=3.4

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                ollama pull gemma3:4b-it-q4_K_M
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma3:4b-it-q4_K_M.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          5)

            echo ""
            echo "  Instalando gemma3:4b-it-q8_0..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=5.1

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                ollama pull gemma3:4b-it-q8_0
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma3:4b-it-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          6)

            echo ""
            echo "  Instalando gemma3:4b-it-fp16..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=8.7

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                ollama pull gemma3:4b-it-fp16
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma3:4b-it-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          7)

            echo ""
            echo "  Instalando gemma3:12b-it-q4_K_M..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=8.2

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                ollama pull gemma3:12b-it-q4_K_M
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma3:12b-it-q4_K_M.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          8)

            echo ""
            echo "  Instalando gemma3:12b-it-q8_0..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=13.2

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                ollama pull gemma3:12b-it-q8_0
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma3:12b-it-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          9)

            echo ""
            echo "  Instalando gemma3:12b-it-fp16..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=24.2

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                ollama pull gemma3:12b-it-fp16
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma3:12b-it-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         10)

            echo ""
            echo "  Instalando gemma3:27b-it-q4_K_M..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=17.2

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                ollama pull gemma3:27b-it-q4_K_M
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma3:27b-it-q4_K_M.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         11)

            echo ""
            echo "  Instalando gemma3:27b-it-q8_0..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=29.2

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                ollama pull gemma3:27b-it-q8_0
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma3:27b-it-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         12)

            echo ""
            echo "  Instalando gemma3:27b-it-fp16..."
            echo ""

            # Definir el espacio que ocupa el modelo
              vEspacioQueOcupaElModelo=54.2

            # Calcular espacio libre disponible antes de instalar el modelo
              if fCalcularEspacioLibreEnCarpetaDeModelos $vEspacioQueOcupaElModelo; then
                # Descargar
                ollama pull gemma3:27b-it-fp16
              else
                # Obtener el espacio libre en la partición raíz en kilobytes
                  vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
                  vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo gemma3:27b-it-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vEspacioQueOcupaElModelo GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

      esac

  done
