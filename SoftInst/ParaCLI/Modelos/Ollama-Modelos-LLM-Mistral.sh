#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los diferentes modelos LLM de Mistral para Ollama en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Modelos/Ollama-Modelos-LLM-Mistral.sh | bash
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Modelos/Ollama-Modelos-LLM-Mistral.sh | sed 's-sudo--g' | bash
# ----------

     40 "mistral 7b-instruct-q4_0 ( 4,2 GB en disco) ( 7,2 GB en VRAM)" off
     41 "mistral 7b-instruct-q8_0 ( 7,8 GB en disco) (15,0 GB en VRAM)" off
     42 "mistral 7b-instruct-fp16 (14,2 GB en disco) ( x,x GB en VRAM)?" off
