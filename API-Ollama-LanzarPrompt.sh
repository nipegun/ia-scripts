#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para consultar la API de Ollama desde bash
#
# Ejecución remota con parámetros (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/API-Ollama-LanzarPrompt.sh | sudo bash -s [IP] [Puerto] ['Modelo'] ['Prompt']
#
# Ejecución remota con parámetros vomo root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/API-Ollama-LanzarPrompt.sh | sed 's-sudo--g' | bash -s [IP] [Puerto] ['Modelo'] ['Prompt']
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/API-Ollama-LanzarPrompt.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Definir la cantidad de argumentos esperados
  cCantParamEsperados=4

# Comprobar que se hayan pasado la cantidad de parámetros correctos. Abortar el script si no.
  if [ $# -ne $cCantParamEsperados ]
    then
      echo ""
      echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
      echo ""
      if [[ "$0" == "bash" ]]; then
        vNombreDelScript="script.sh"
      else
        vNombreDelScript="$0"
      fi
      echo "    $vNombreDelScript [IP] [Puerto] ['Modelo'] ['Prompt']"
      echo ""
      echo "  Ejemplo:"
      echo ""
      echo "    $vNombreDelScript '10.5.0.254' '11434' 'llama3.1:8b-instruct-q8_0' 'Cuéntame un chiste'"
      echo ""
      exit
  fi

# Pasar parámetros a variables
  vIP="$1"
  vPuerto="$2"
  vModelo="$3"
  vPrompt="$4"

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install curl
    echo ""
  fi

# Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install jq
    echo ""
  fi

# Realizar la consulta
  curl -s http://"$vIP":"$vPuerto"/api/generate -d '{ "model": "'"$vModelo"'", "prompt": "'"$1"'", "stream": false }' | jq -r .response

