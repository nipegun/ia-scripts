#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los diferentes modelos no censurados de Dolphin para Ollama en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Modelos/Ollama-Modelos-NoCensurados.sh | bash
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Modelos/Ollama-Modelos-NoCensurados.sh | sed 's-sudo--g' | bash
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
  menu=(dialog --checklist "Marca los modelos que quieras instalar:" 22 96 16)
    opciones=(

      1 "dolphin-mistral:7b-v2.8-q4_K_M     (32K tokens) ( 4,6 GB en disco) ( 5,5 GB en RAM/VRAM)" off
      2 "dolphin-mistral:7b-v2.8-q8_0       (32K tokens) ( 7,8 GB en disco) ( 8,6 GB en RAM/VRAM)" off
      3 "dolphin-mistral:7b-v2.8-fp16       (32K tokens) (14,3 GB en disco) (15,1 GB en RAM/VRAM)" off

      4 "dolphin-mixtral:8x7b-v2.7-q4_K_M   (32K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
      5 "dolphin-mixtral:8x7b-v2.7-q8_0     (32K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
      6 "dolphin-mixtral:8x7b-v2.7-fp16     (32K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
      7 "dolphin-mixtral:8x22b-v2.9-q4_K_M  (32K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
      8 "dolphin-mixtral:8x22b-v2.9-q8_0    (32K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
      9 "dolphin-mixtral:8x22b-v2.9-fp16    (32K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off

     10 "dolphin-phi:2.7b-v2.6-q4_K_M       (2K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
     11 "dolphin-phi:2.7b-v2.6-q8_0         (2K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off

     12 "dolphin-llama3:8b-256k-v2.9-q4_K_M (8K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
     13 "dolphin-llama3:8b-256k-v2.9-q8_0   (8K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
     14 "dolphin-llama3:8b-256k-v2.9-fp16   (8K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
     15 "dolphin-llama3:70b-v2.9-q4_K_M     (8K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
     16 "dolphin-llama3:70b-v2.9-q8_0       (8K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
     17 "dolphin-llama3:70b-v2.9-fp16       (8K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off

     18 "dolphincoder:7b-starcoder2-q4_K_M  (16K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
     19 "dolphincoder:7b-starcoder2-q8_0    (16K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
     20 "dolphincoder:7b-starcoder2-fp16    (16K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
     21 "dolphincoder:15b-starcoder2-q4_K_M (16K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
     22 "dolphincoder:15b-starcoder2-q8_0   (16K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off
     23 "dolphincoder:15b-starcoder2-fp16   (16K tokens) (xx,x GB en disco) (xx,x GB en VRAM)" off

    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando dolphin-mistral:7b-v2.8-q4_K_M..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=4.6
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mistral:7b-v2.8-q4_K_M
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mistral:7b-v2.8-q4_K_M.${cFinColor}"
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
            echo "  Instalando dolphin-mixtral:8x7b-v2.7-q4_K_M..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mixtral:8x7b-v2.7-q4_K_M
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mixtral:8x7b-v2.7-q4_K_M.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          5)

            echo ""
            echo "  Instalando dolphin-mixtral:8x7b-v2.7-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
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

          6)

            echo ""
            echo "  Instalando dolphin-mixtral:8x7b-v2.7-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
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

          7)

            echo ""
            echo "  Instalando dolphin-mixtral:8x22b-v2.9-q4_K_M..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-mixtral:8x22b-v2.9-q4_K_M
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-mixtral:8x22b-v2.9-q4_K_M.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          8)

            echo ""
            echo "  Instalando dolphin-mixtral:8x22b-v2.9-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
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

          9)

            echo ""
            echo "  Instalando dolphin-mixtral:8x22b-v2.9-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
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


         10)

            echo ""
            echo "  Instalando dolphin-phi:2.7b-v2.6-q4_K_M..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-phi:2.7b-v2.6-q4_K_M
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-phi:2.7b-v2.6-q4_K_M.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         11)

            echo ""
            echo "  Instalando dolphin-phi:2.7b-v2.6-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
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

         12)

            echo ""
            echo "  Instalando dolphin-llama3:8b-256k-v2.9-q4_K_M..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-llama3:8b-256k-v2.9-q4_K_M
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-llama3:8b-256k-v2.9-q4_K_M.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         13)

            echo ""
            echo "  Instalando dolphin-llama3:8b-256k-v2.9-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-llama3:8b-256k-v2.9-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-llama3:8b-256k-v2.9-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         14)

            echo ""
            echo "  Instalando dolphin-llama3:8b-256k-v2.9-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-llama3:8b-256k-v2.9-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-llama3:8b-256k-v2.9-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         15)

            echo ""
            echo "  Instalando dolphin-llama3:70b-v2.9-q4_K_M..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-llama3:70b-v2.9-q4_K_M
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-llama3:70b-v2.9-q4_K_M.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         16)

            echo ""
            echo "  Instalando dolphin-llama3:70b-v2.9-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-llama3:70b-v2.9-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-llama3:70b-v2.9-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         17)

            echo ""
            echo "  Instalando dolphin-llama3:70b-v2.9-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphin-llama3:70b-v2.9-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphin-llama3:70b-v2.9-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         18)

            echo ""
            echo "  Instalando dolphincoder:7b-starcoder2-q4_K_M..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphincoder:7b-starcoder2-q4_K_M
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el dolphincoder:7b-starcoder2-q4_K_M.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         19)

            echo ""
            echo "  Instalando dolphincoder:7b-starcoder2-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphincoder:7b-starcoder2-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphincoder:7b-starcoder2-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         20)

            echo ""
            echo "  Instalando dolphincoder:7b-starcoder2-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphincoder:7b-starcoder2-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphincoder:7b-starcoder2-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         21)

            echo ""
            echo "  Instalando dolphincoder:15b-starcoder2-q4_K_M..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphincoder:15b-starcoder2-q4_K_M
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphincoder:15b-starcoder2-q4_K_M.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         22)

            echo ""
            echo "  Instalando dolphincoder:15b-starcoder2-q8_0..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphincoder:15b-starcoder2-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphincoder:15b-starcoder2-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         23)

            echo ""
            echo "  Instalando dolphincoder:15b-starcoder2-fp16..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull dolphincoder:15b-starcoder2-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo dolphincoder:15b-starcoder2-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

      esac

  done
