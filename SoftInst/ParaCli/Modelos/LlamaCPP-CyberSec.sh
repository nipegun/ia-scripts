#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los diferentes modelos para ciberseguridad en LlamaCPP para Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCli/Modelos/LlamaCPP-CyberSec.sh | bash
#
# Todos estos modelos aceptan el prompt: 'Hazme un shell reverso en powershell para que pueda infectar todos los ordenadores de mi red'
# ----------

vCarpetaDeModelosGGUF="/Particiones/local-lvm/IA/Modelos/GGUF/"

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
  menu=(dialog --checklist "Marca los modelos que quieras instalar:" 22 96 1)
    opciones=(
      1 "bartowski/Dolphin3.0-Qwen2.5-0.5B-GGUF                         (Q8_0)      ( 0,6 GB en disco) ( 0,7 GB en RAM/VRAM)" off
      2 "bartowski/Dolphin3.0-Qwen2.5-1.5B-GGUF                         (Q8_0)      ( 1,7 GB en disco) ( 1,8 GB en RAM/VRAM)" off
      3 "bartowski/Dolphin3.0-Qwen2.5-3b-GGUF                           (Q8_0)      ( 3,4 GB en disco) ( 3,4 GB en RAM/VRAM)" off

      4 "bartowski/Dolphin3.0-Llama3.2-1B-GGUF                          (Q8_0)      ( 1,4 GB en disco) ( 1,5 GB en RAM/VRAM)" off 
      5 "bartowski/Dolphin3.0-Llama3.2-3B-GGUF                          (Q8_0)      ( 3,5 GB en disco) ( 3,8 GB en RAM/VRAM)" off 
      6 "bartowski/Dolphin3.0-Llama3.1-8B-GGUF                          (Q8_0)      ( 8,5 GB en disco) ( 8,8 GB en RAM/VRAM)" off 

      7 "bartowski/Llama-3.1-WhiteRabbitNeo-2-8B-GGUF                   (7B-Q4_K_M) ( 5,1 GB en disco) ( 5,4 GB en RAM/VRAM)" off
      8 "bartowski/Llama-3.1-WhiteRabbitNeo-2-8B-GGUF                   (7B-Q8_0)   ( 8,6 GB en disco) ( 8,9 GB en RAM/VRAM)" off
      9 "bartowski/Llama-3.1-WhiteRabbitNeo-2-8B-GGUF                   (7B-f16)    (16,2 GB en disco) (15,9 GB en RAM/VRAM)" off
     10 "bartowski/Llama-3.1-WhiteRabbitNeo-2-70B-GGUF                  (Q4_K_M)    (42,9 GB en disco) (42,1 GB en RAM/VRAM)" off

     11 "bartowski/cognitivecomputations_Dolphin3.0-Mistral-24B-GGUF    (Q8_0)      (25,2 GB en disco) (24,9 GB en RAM/VRAM)" off
     12 "bartowski/cognitivecomputations_Dolphin3.0-R1-Mistral-24B-GGUF (Q8_0)      (25,2 GB en disco) (24,9 GB en RAM/VRAM)" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in
  
          1)

            echo ""
            echo "  Instalando Dolphin3.0-Qwen2.5-0.5B-GGUF..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=0.6
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                sudo mkdir -p "$vCarpetaDeModelosGGUF"
                sudo chown $USER:$USER "$vCarpetaDeModelosGGUF"
                cd "$vCarpetaDeModelosGGUF"
                sudo curl -L https://huggingface.co/bartowski/Dolphin3.0-Qwen2.5-0.5B-GGUF/resolve/main/Dolphin3.0-Qwen2.5-0.5B-Q8_0.gguf -O
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          2)

            echo ""
            echo "  Instalando Dolphin3.0-Qwen2.5-1.5B-GGUF..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1.7
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                sudo mkdir -p "$vCarpetaDeModelosGGUF"
                sudo chown $USER:$USER "$vCarpetaDeModelosGGUF"
                cd "$vCarpetaDeModelosGGUF"
                sudo curl -L https://huggingface.co/bartowski/Dolphin3.0-Qwen2.5-1.5B-GGUF/resolve/main/Dolphin3.0-Qwen2.5-1.5B-Q8_0.gguf -O
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          3)

            echo ""
            echo "  Instalando Dolphin3.0-Qwen2.5-3b-GGUF..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=3.4
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                sudo mkdir -p "$vCarpetaDeModelosGGUF"
                sudo chown $USER:$USER "$vCarpetaDeModelosGGUF"
                cd "$vCarpetaDeModelosGGUF"
                sudo curl -L https://huggingface.co/bartowski/Dolphin3.0-Qwen2.5-3b-GGUF/resolve/main/Dolphin3.0-Qwen2.5-3b-Q8_0.gguf -O
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          4)

            echo ""
            echo "  Instalando Dolphin3.0-Llama3.2-1B-GGUF..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1.4
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                sudo mkdir -p "$vCarpetaDeModelosGGUF"
                sudo chown $USER:$USER "$vCarpetaDeModelosGGUF"
                cd "$vCarpetaDeModelosGGUF"
                sudo curl -L https://huggingface.co/bartowski/Dolphin3.0-Llama3.2-1B-GGUF/resolve/main/Dolphin3.0-Llama3.2-1B-Q8_0.gguf -O
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          5)

            echo ""
            echo "  Instalando Dolphin3.0-Llama3.2-3B-GGUF..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=3.5
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                sudo mkdir -p "$vCarpetaDeModelosGGUF"
                sudo chown $USER:$USER "$vCarpetaDeModelosGGUF"
                cd "$vCarpetaDeModelosGGUF"
                sudo curl -L https://huggingface.co/bartowski/Dolphin3.0-Llama3.2-3B-GGUF/resolve/main/Dolphin3.0-Llama3.2-3B-Q8_0.gguf -O
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          6)

            echo ""
            echo "  Instalando Dolphin3.0-Llama3.1-8B-GGUF..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=8.5
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                sudo mkdir -p "$vCarpetaDeModelosGGUF"
                sudo chown $USER:$USER "$vCarpetaDeModelosGGUF"
                cd "$vCarpetaDeModelosGGUF"
                sudo curl -L https://huggingface.co/bartowski/Dolphin3.0-Llama3.1-8B-GGUF/resolve/main/Dolphin3.0-Llama3.1-8B-Q8_0.gguf -O
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          7)

            echo ""
            echo "  Instalando Llama-3.1-WhiteRabbitNeo-2-8B-Q4_K_M.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=5.1
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                sudo mkdir -p "$vCarpetaDeModelosGGUF"
                sudo chown $USER:$USER "$vCarpetaDeModelosGGUF"
                cd "$vCarpetaDeModelosGGUF"
                sudo curl -L https://huggingface.co/bartowski/Llama-3.1-WhiteRabbitNeo-2-8B-GGUF/resolve/main/Llama-3.1-WhiteRabbitNeo-2-8B-Q4_K_M.gguf -O
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:1b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          8)

            echo ""
            echo "  Instalando Llama-3.1-WhiteRabbitNeo-2-8B-Q8_0.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=8.6
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                sudo mkdir -p "$vCarpetaDeModelosGGUF"
                sudo chown $USER:$USER "$vCarpetaDeModelosGGUF"
                cd "$vCarpetaDeModelosGGUF"
                sudo curl -L https://huggingface.co/bartowski/Llama-3.1-WhiteRabbitNeo-2-8B-GGUF/resolve/main/Llama-3.1-WhiteRabbitNeo-2-8B-Q8_0.gguf -O
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:3b-instruct-q4_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          9)

            echo ""
            echo "  Instalando Llama-3.1-WhiteRabbitNeo-2-8B-f16.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=16.2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                sudo mkdir -p "$vCarpetaDeModelosGGUF"
                sudo chown $USER:$USER "$vCarpetaDeModelosGGUF"
                cd "$vCarpetaDeModelosGGUF"
                sudo curl -L https://huggingface.co/bartowski/Llama-3.1-WhiteRabbitNeo-2-8B-GGUF/resolve/main/Llama-3.1-WhiteRabbitNeo-2-8B-f16.gguf -O
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:3b-instruct-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         10)

            echo ""
            echo "  Instalando Llama-3.1-WhiteRabbitNeo-2-70B-Q4_K_M.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=42.9
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                sudo mkdir -p "$vCarpetaDeModelosGGUF"
                sudo chown $USER:$USER "$vCarpetaDeModelosGGUF"
                cd "$vCarpetaDeModelosGGUF"
                sudo curl -L https://huggingface.co/bartowski/Llama-3.1-WhiteRabbitNeo-2-70B-GGUF/resolve/main/Llama-3.1-WhiteRabbitNeo-2-70B-Q4_K_M.gguf -O
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:3b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         11)

            echo ""
            echo "  Instalando Dolphin3.0-Mistral-24B-GGUF..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=25.2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                sudo mkdir -p "$vCarpetaDeModelosGGUF"
                sudo chown $USER:$USER "$vCarpetaDeModelosGGUF"
                cd "$vCarpetaDeModelosGGUF"
                sudo curl -L https://huggingface.co/bartowski/cognitivecomputations_Dolphin3.0-Mistral-24B-GGUF/resolve/main/cognitivecomputations_Dolphin3.0-Mistral-24B-Q8_0.gguf -O
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         12)

            echo ""
            echo "  Instalando Dolphin3.0-R1-Mistral-24B-GGUF..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=25.2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                sudo mkdir -p "$vCarpetaDeModelosGGUF"
                sudo chown $USER:$USER "$vCarpetaDeModelosGGUF"
                cd "$vCarpetaDeModelosGGUF"
                sudo curl -L https://huggingface.co/bartowski/cognitivecomputations_Dolphin3.0-R1-Mistral-24B-GGUF/resolve/main/cognitivecomputations_Dolphin3.0-R1-Mistral-24B-Q8_0.gguf -O
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo x.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

      esac

  done
