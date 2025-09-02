#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los diferentes modelos LLM GGUF de Llama para Text Generation Web UI en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Modelos/TextGenerationWebUI-Modelos-Llama.sh | bash
# ----------

# Definir la carpeta de los modelos
  vCarpeta="/opt/text-generation-webui/models/"

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Indicar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modelos LLM de Llama para Text Generation Web UI...${cFinColor}"
  echo ""

# Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install dialog
    echo ""
  fi

# Crear el menú
  menu=(dialog --checklist "Marca los modelos que quieras instalar:" 22 96 16)
    opciones=(

      1 "meta-llama/Llama-3.3-70B-Instruct (x,x GB en disco) (x,x GB en RAM/VRAM)" off

      2 "meta-llama/Llama-3.2-1B-Instruct (x,x GB en disco) (x,x GB en RAM/VRAM)" off
      3 "meta-llama/Llama-3.2-3B-Instruct (x,x GB en disco) (x,x GB en RAM/VRAM)" off

      4 "meta-llama/Llama-3.1-8B-Instruct   (x,x GB en disco) (x,x GB en RAM/VRAM)" off
      5 "meta-llama/Llama-3.1-70B-Instruct  (x,x GB en disco) (x,x GB en RAM/VRAM)" off
      6 "meta-llama/Llama-3.1-405B-Instruct (x,x GB en disco) (x,x GB en RAM/VRAM)" off

    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando meta-llama/Llama-3.3-70B-Instruct..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=100.1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                python3 /opt/text-generation-webui/download-model.py meta-llama/Llama-3.3-70B-Instruct
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo meta-llama/Llama-3.3-70B-Instruct.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          2)

            echo ""
            echo "  Instalando meta-llama/Llama-3.2-1B-Instruct..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=100.1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                python3 /opt/text-generation-webui/download-model.py meta-llama/Llama-3.2-1B-Instruct
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo meta-llama/Llama-3.2-1B-Instruct.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          3)

            echo ""
            echo "  Instalando meta-llama/Llama-3.2-3B-Instruct..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=100.1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                python3 /opt/text-generation-webui/download-model.py meta-llama/Llama-3.2-3B-Instruct
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo meta-llama/Llama-3.2-3B-Instruct.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          4)

            echo ""
            echo "  Instalando meta-llama/Llama-3.1-8B-Instruct..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=100.1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                python3 /opt/text-generation-webui/download-model.py meta-llama/Llama-3.1-8B-Instruct
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo meta-llama/Llama-3.1-8B-Instruct0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          5)

            echo ""
            echo "  Instalando meta-llama/Llama-3.1-70B-Instruct..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=100.1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                python3 /opt/text-generation-webui/download-model.py meta-llama/Llama-3.1-70B-Instruct
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo meta-llama/Llama-3.1-70B-Instruct.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          6)

            echo ""
            echo "  meta-llama/Llama-3.1-405B-Instruct..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=100.1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                python3 /opt/text-generation-webui/download-model.py meta-llama/Llama-3.1-405B-Instruct
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo meta-llama/Llama-3.1-405B-Instruct.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

      esac

  done
