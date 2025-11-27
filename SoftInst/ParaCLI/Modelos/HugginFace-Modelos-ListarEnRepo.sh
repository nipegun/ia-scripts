#!/bin/bash

# ----------
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Modelos/HugginFace-Modelos-ListarEnRepo.sh | bash -s [] []
# ---------

vUsuario='DavidAU'
vRepo='OpenAi-GPT-oss-20b-abliterated-uncensored-NEO-Imatrix-gguf'

curl -s https://huggingface.co/api/models/"$vUsuario"/"$vRepo" | grep -i gguf | jq

