#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los diferentes modelos Coder de DeepSeek para Ollama en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Modelos/Ollama-Modelos-CyberSec-WhiteRabbitNeo.sh | bash
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Modelos/Ollama-Modelos-CyberSec-WhiteRabbitNeo.sh | sed 's-sudo--g' | bash
# ----------
     
     49 "deepseek-coder-v2 16b-lite-instruct-q4_K_M (x,x GB en disco) (x,x GB en VRAM)" off
     50 "deepseek-coder-v2 16b-lite-instruct-q8_0   (x,x GB en disco) (x,x GB en VRAM)" off
     51 "deepseek-coder-v2 16b-lite-instruct-fp16   (x,x GB en disco) (x,x GB en VRAM)" off
     
     52 "deepseek-coder-v2 236b-instruct-q4_K_M (x,x GB en disco) (x,x GB en VRAM)" off
     53 "deepseek-coder-v2 236b-instruct-q8_0   (x,x GB en disco) (x,x GB en VRAM)" off
     54 "deepseek-coder-v2 236b-instruct-fp16   (x,x GB en disco) (x,x GB en VRAM)" off



estos modelos están correctos
