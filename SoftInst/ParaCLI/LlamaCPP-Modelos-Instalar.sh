#!/bin/bash



# Descargar modelos
  mkdir -p ~/IA/Modelos/GGUF/
  cd ~/IA/Modelos/GGUF/
  # Oficiales
    curl -L https://huggingface.co/lmstudio-community/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q8_0.gguf -O
    curl -L https://huggingface.co/lmstudio-community/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-MXFP4.gguf -O
    curl -L https://huggingface.co/DavidAU/resolve/main/OpenAi-GPT-oss-20b-abliterated-uncensored-NEO-Imatrix-gguf:Q8_0 -O


  # Para lanzar de manera oficial
    ./llama-server -hf lmstudio-community/gpt-oss-20b-GGUF/gpt-oss-20b.Q4_K_M.gguf
    ./llama-server -hf DavidAU/OpenAi-GPT-oss-20b-abliterated-uncensored-NEO-Imatrix-gguf:Q8_0
  # Para lanzar con el modelo en la carpeta personal
    $HOME/IA/LlamaCPP/llama-server -hf ~/IA/Modelos/GGUF/gpt-oss-20b.Q4_K_M.gguf
    huggingface-cli download OWNER/REPO --include "*.gguf" --local-dir .

  # No censurados
    curl -L https://huggingface.co/DavidAU/resolve/main/OpenAI-20B-NEO-CODE-DI-Uncensored-Q8_0.gguf -O
    curl -L https://huggingface.co/DavidAU/resolve/main/OpenAi-GPT-oss-20b-abliterated-uncensored-NEO-Imatrix-Q8_0.gguf -O
  # Servirlo
  $HOME/IA/LlamaCPP/llama-server -hf ~/IA/Modelos/GGUF/gpt-oss-20b.Q4_K_M.gguf
