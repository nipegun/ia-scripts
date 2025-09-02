#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar diferentes modelos GGUF para Text Generation Web UI en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/LMStudio-Modelos-Instalar-LLM.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/LMStudio-Modelos-Instalar-LLM.sh | bash
# ----------

vCarpeta="/opt/text-generation-webui/models/"


            #Use the download-model.py script to automatically download a model from Hugging Face. /opt/text-generation-webui/download-model.py

chmod +x /opt/text-generation-webui/download-model.py
cd /opt/text-generation-webui/

# Instalar requisitos
  sudo apt-get update
  sudo apt-get -y install python3-pip
  pip3 install tqdm --break-system-packages



python3 ./download-model.py
