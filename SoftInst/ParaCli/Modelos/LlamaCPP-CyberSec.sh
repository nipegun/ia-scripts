#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los diferentes modelos para ciberseguridad en LlamaCPP para Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCli/Modelos/LlamaCPP-CyberSec | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

vCarpetaDeModelosGGUF="/Particiones/local-lvm/IA/Modelos/GGUF/"
      
# Indicar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modelos LLM de Llama para Ollama...${cFinColor}"
  echo ""

sudo mkdir -p "$vCarpetaDeModelosGGUF"
sudo chown $USER:$USER "$vCarpetaDeModelosGGUF"

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
      1 "TheBloke/WhiteRabbitNeo-13B-GGUF    (Q8_0)                      (x,x GB en disco) (x,x GB en RAM/VRAM)" off
      2 "TheBloke/WhiteRabbitNeo-33B-v1-GGUF (Q8_0)                      (x,x GB en disco) (x,x GB en RAM/VRAM)" off

      3 "bartowski/WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-GGUF (7B-Q4_K_M) (x,x GB en disco) (x,x GB en RAM/VRAM)" off
      4 "bartowski/WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-GGUF (7B-Q8_0)   (x,x GB en disco) (x,x GB en RAM/VRAM)" off
      5 "bartowski/WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-GGUF (7B-f16)    (x,x GB en disco) (x,x GB en RAM/VRAM)" off

      6 "bartowski/Llama-3.1-WhiteRabbitNeo-2-8B-GGUF (7B-Q4_K_M)        (x,x GB en disco) (x,x GB en RAM/VRAM)" off
      7 "bartowski/Llama-3.1-WhiteRabbitNeo-2-8B-GGUF (7B-Q8_0)          (x,x GB en disco) (x,x GB en RAM/VRAM)" off
      8 "bartowski/Llama-3.1-WhiteRabbitNeo-2-8B-GGUF (7B-f16)           (x,x GB en disco) (x,x GB en RAM/VRAM)" off

      9 "bartowski/Llama-3.1-WhiteRabbitNeo-2-70B-GGUF (Q4_K_M)          (x,x GB en disco) (x,x GB en RAM/VRAM)" off

     10 "mradermacher/Trinity-13B-GGUF    (Q4_K_M)                       (x,x GB en disco) (x,x GB en RAM/VRAM)" off
     11 "mradermacher/Trinity-13B-GGUF    (Q8_0)                         (x,x GB en disco) (x,x GB en RAM/VRAM)" off
     12 "mradermacher/Trinity-13B-i1-GGUF (i1-Q6_K)                      (x,x GB en disco) (x,x GB en RAM/VRAM)" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in


      cd "$vCarpetaDeModelosGGUF"
      sudo curl -L https://huggingface.co/TheBloke/WhiteRabbitNeo-13B-GGUF/resolve/main/whiterabbitneo-13b.Q8_0.gguf -O
      sudo curl -L https://huggingface.co/TheBloke/WhiteRabbitNeo-33B-v1-GGUF/resolve/main/whiterabbitneo-33b-v1.Q8_0.gguf -O

      sudo curl -L https://huggingface.co/bartowski/WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-GGUF/resolve/main/WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-Q4_K_M.gguf -O
      sudo curl -L https://huggingface.co/bartowski/WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-GGUF/resolve/main/WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-Q8_0.gguf -O
      sudo curl -L https://huggingface.co/bartowski/WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-GGUF/resolve/main/WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-f16.gguf -O

      sudo curl -L https://huggingface.co/bartowski/Llama-3.1-WhiteRabbitNeo-2-8B-GGUF/resolve/main/Llama-3.1-WhiteRabbitNeo-2-8B-Q4_K_M.gguf -O
      sudo curl -L https://huggingface.co/bartowski/Llama-3.1-WhiteRabbitNeo-2-8B-GGUF/resolve/main/Llama-3.1-WhiteRabbitNeo-2-8B-Q8_0.gguf -O
      sudo curl -L https://huggingface.co/bartowski/Llama-3.1-WhiteRabbitNeo-2-8B-GGUF/resolve/main/Llama-3.1-WhiteRabbitNeo-2-8B-f16.gguf -O

      sudo curl -L https://huggingface.co/bartowski/Llama-3.1-WhiteRabbitNeo-2-70B-GGUF/resolve/main/Llama-3.1-WhiteRabbitNeo-2-70B-Q4_K_M.gguf -O

      sudo curl -L https://huggingface.co/mradermacher/Trinity-13B-GGUF/resolve/main/Trinity-13B.Q4_K_M.gguf -O
      sudo curl -L https://huggingface.co/mradermacher/Trinity-13B-GGUF/resolve/main/Trinity-13B.Q8_0.gguf -O
      sudo curl -L https://huggingface.co/mradermacher/Trinity-13B-i1-GGUF/resolve/main/Trinity-13B.i1-Q6_K.gguf -O


  
          1)

            echo ""
            echo "  Instalando whiterabbitneo-13b.Q8_0.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=13
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p ~/IA/Modelos/GGUF/
                cd ~/IA/Modelos/GGUF/
                
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.3:70b-instruct-q4_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          2)

            echo ""
            echo "  Instalando whiterabbitneo-33b-v1.Q8_0.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=76
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p ~/IA/Modelos/GGUF/
                cd ~/IA/Modelos/GGUF/
                curl -L https://huggingface.co/TheBloke/WhiteRabbitNeo-13B-GGUF/resolve/main/whiterabbitneo-13b.fp16.gguf -O
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.3:70b-instruct-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          3)

            echo ""
            echo "  Instalando WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-Q4_K_M.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=142
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p ~/IA/Modelos/GGUF/
                cd ~/IA/Modelos/GGUF/
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.3:70b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          4)

            echo ""
            echo "  Instalando WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-Q8_0.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=0.9
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p ~/IA/Modelos/GGUF/
                cd ~/IA/Modelos/GGUF/
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:1b-instruct-q4_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          5)

            echo ""
            echo "  Instalando WhiteRabbitNeo-2.5-Qwen-2.5-Coder-7B-f16.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=1.5
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p ~/IA/Modelos/GGUF/
                cd ~/IA/Modelos/GGUF/
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:1b-instruct-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          6)

            echo ""
            echo "  Instalando Llama-3.1-WhiteRabbitNeo-2-8B-Q4_K_M.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2.7
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p ~/IA/Modelos/GGUF/
                cd ~/IA/Modelos/GGUF/
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:1b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          7)

            echo ""
            echo "  Instalando Llama-3.1-WhiteRabbitNeo-2-8B-Q8_0.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                mkdir -p ~/IA/Modelos/GGUF/
                cd ~/IA/Modelos/GGUF/
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:3b-instruct-q4_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          8)

            echo ""
            echo "  Instalando Llama-3.1-WhiteRabbitNeo-2-8B-f16.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=3.6
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then

              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:3b-instruct-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

          9)

            echo ""
            echo "  Instalando Llama-3.1-WhiteRabbitNeo-2-70B-Q4_K_M.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=6.6
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.2:3b-instruct-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.2:3b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         10)

            echo ""
            echo "  Instalando Trinity-13B.Q4_K_M.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=4.8
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:8b-instruct-q4_0 
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:8b-instruct-q4_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         11)

            echo ""
            echo "  Instalando Trinity-13B.Q8_0.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=8.6
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:8b-instruct-q8_0
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:8b-instruct-q8_0.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

         12)

            echo ""
            echo "  Instalando Trinity-13B.i1-Q6_K.gguf..."
            echo ""

            # Definir el espacio libre necesario
              vGBsLibresNecesarios=16.2
              vEspacioNecesario=$(($vGBsLibresNecesarios * 1024 * 1024)) # Convertir a kilobytes (1GB = 1048576KB)

            # Obtener el espacio libre en la partición raíz en kilobytes
              vEspacioLibre=$(df / | grep '/' | tail -1 | sed -E 's/\s+/ /g' | cut -d ' ' -f 4)
              vGBsLibres=$(echo "scale=2; $vEspacioLibre/1024/1024" | bc)

            # Comprobar si hay espacio libre disponible
              if [ "$vEspacioLibre" -ge "$vEspacioNecesario" ]; then
                ollama pull llama3.1:8b-instruct-fp16
              else
                echo ""
                echo -e "${cColorRojo}    No hay suficiente espacio libre para instalar el modelo llama3.1:8b-instruct-fp16.${cFinColor}"
                echo ""
                echo -e "${cColorRojo}      Hacen falta $vGBsLibresNecesarios GB y hay sólo $vGBsLibres GB.${cFinColor}"
                echo ""
              fi

          ;;

      esac

  done
