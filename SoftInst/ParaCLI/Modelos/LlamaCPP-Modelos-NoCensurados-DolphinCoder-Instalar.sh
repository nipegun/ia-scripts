#!/bin/bash

cd $HOME/IA/Modelos/GGUF/
curl -L https://huggingface.co/bartowski/dolphincoder-starcoder2-15b-GGUF/resolve/main/dolphincoder-starcoder2-15b-Q8_0.gguf -O
# Servir
  # $HOME/IA/LlamaCPP/llama-server -m $HOME/IA/Modelos/GGUF/dolphincoder-starcoder2-15b-Q8_0.gguf --port 9000


cd $HOME/IA/Modelos/GGUF/
curl -L https://huggingface.co/bartowski/dolphincoder-starcoder2-15b-GGUF/resolve/main/dolphincoder-starcoder2-15b-Q4_K_M.gguf -O
# Servir
  # $HOME/IA/LlamaCPP/llama-server -m $HOME/IA/Modelos/GGUF/dolphincoder-starcoder2-15b-Q4_K_M.gguf --port 9000
