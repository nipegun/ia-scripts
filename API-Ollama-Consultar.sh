#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para consultar la API de Ollama desde bash
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL x | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL x | sed 's-sudo--g' | bash
#
# Ejecución remota con parámetros:
#   curl -sL x | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL x | nano -
# ----------

vIP="$2"
vIP=""

vPuerto="$3"
vPuerto='11434'

vModelo="$4"
vModelo='llama3.1:8b-instruct-q8_0'


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
  curl -s http://"$vIP":"$vPuerto"/api/generate -d '{ "model": "$vModelo", "prompt": "'"$1"'", "stream": false }' | jq -r .response

