#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los diferentes modelos de Dolphin Uncensored en Ollama para Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCli/Modelos/Ollama-Dolphin-Mistral.sh | bash
# ----------

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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modelos LLM de Llama para Ollama...${cFinColor}"
  echo ""

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo ""
    echo -e "${cColorRojo}    Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    echo ""
    exit
  fi

# Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update && apt-get -y install dialog
    echo ""
  fi

# Crear el menú
  menu=(dialog --checklist "Marca los modelos que quieras instalar:" 22 96 16)
    opciones=(

      1 "dolphin-mistral 7b-v2.8-q4_0    ( 4,2 GB en disco) ( 5,1 GB en RAM/VRAM)" off
      2 "dolphin-mistral 7b-v2.8-q8_0    ( 7,8 GB en disco) ( 8,6 GB en RAM/VRAM)" off
      3 "dolphin-mistral 7b-v2.8-fp16    (14,3 GB en disco) (15,1 GB en RAM/VRAM)" off

      4 "dolphin-mixtral 8x7b-v2.7-q4_0  (xx,x GB en disco) (xx,x GB en VRAM)" off
      5 "dolphin-mixtral 8x7b-v2.7-q8_0  (xx,x GB en disco) (xx,x GB en VRAM)" off
      6 "dolphin-mixtral 8x7b-v2.7-fp16  (xx,x GB en disco) (xx,x GB en VRAM)" off

      7 "dolphin-mixtral 8x22b-v2.9-q4_0 (xx,x GB en disco) (xx,x GB en VRAM)" off
      8 "dolphin-mixtral 8x22b-v2.9-q8_0 (xx,x GB en disco) (xx,x GB en VRAM)" off
      9 "dolphin-mixtral 8x22b-v2.9-fp16 (xx,x GB en disco) (xx,x GB en VRAM)" off

     10 "dolphin-phi 2.7b-v2.6-q8_0 (xx,x GB en disco) (xx,x GB en VRAM)" off

     11 "dolphin-llama3 8b-256k-v2.9-q4_0 (xx,x GB en disco) (xx,x GB en VRAM)" off
     12 "dolphin-llama3 8b-256k-v2.9-q8_0 (xx,x GB en disco) (xx,x GB en VRAM)" off
     13 "dolphin-llama3 8b-256k-v2.9-fp16 (xx,x GB en disco) (xx,x GB en VRAM)" off
     14 "dolphin-llama3 70b-v2.9-q4_0     (xx,x GB en disco) (xx,x GB en VRAM)" off
     15 "dolphin-llama3 70b-v2.9-q8_0     (xx,x GB en disco) (xx,x GB en VRAM)" off
     16 "dolphin-llama3 70b-v2.9-fp16     (xx,x GB en disco) (xx,x GB en VRAM)" off

    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando dolphin-mistral:7b-v2.8-q4_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=4.2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mistral:7b-v2.8-q4_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mistral:7b-v2.8-q4_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          2)

            echo ""
            echo "  Instalando dolphin-mistral:7b-v2.8-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=7.8
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mistral:7b-v2.8-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mistral:7b-v2.8-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          3)

            echo ""
            echo "  Instalando dolphin-mistral:7b-v2.8-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=14.3
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mistral:7b-v2.8-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mistral:7b-v2.8-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          4)

            echo ""
            echo "  Instalando dolphin-mixtral:8x7b-v2.5-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=x
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mixtral:8x7b-v2.5-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mixtral:8x7b-v2.5-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          5)

            echo ""
            echo "  Instalando dolphin-mixtral:8x7b-v2.5-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=x
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mixtral:8x7b-v2.5-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mixtral:8x7b-v2.5-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          6)

            echo ""
            echo "  Instalando dolphin-mixtral:8x7b-v2.6-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=x
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mixtral:8x7b-v2.6-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mixtral:8x7b-v2.6-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          7)

            echo ""
            echo "  Instalando dolphin-mixtral:8x7b-v2.6-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=x
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mixtral:8x7b-v2.6-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mixtral:8x7b-v2.6-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          8)

            echo ""
            echo "  Instalando dolphin-mixtral:8x7b-v2.7-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=x
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mixtral:8x7b-v2.7-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mixtral:8x7b-v2.7-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          9)

            echo ""
            echo "  Instalando dolphin-mixtral:8x7b-v2.7-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=x
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mixtral:8x7b-v2.7-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mixtral:8x7b-v2.7-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         10)

            echo ""
            echo "  Instalando dolphin-mixtral:8x22b-v2.9-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=x
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mixtral:8x22b-v2.9-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mixtral:8x22b-v2.9-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         11)

            echo ""
            echo "  Instalando dolphin-mixtral:8x22b-v2.9-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=x
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mixtral:8x22b-v2.9-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mixtral:8x22b-v2.9-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         12)

            echo ""
            echo "  dolphin-phi:2.7b-v2.6-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=x
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-phi:2.7b-v2.6-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-phi:2.7b-v2.6-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

      esac

  done
