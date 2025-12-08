#!/bin/bash

cd $HOME/IA/Modelos/GGUF/
curl -L https://huggingface.co/bartowski/dolphincoder-starcoder2-15b-GGUF/resolve/main/dolphincoder-starcoder2-15b-Q8_0.gguf -O
# Servir
  # $HOME/IA/LlamaCPP/llama-server -m $HOME/IA/Modelos/GGUF/dolphincoder-starcoder2-15b-Q8_0.gguf --port 9000


cd $HOME/IA/Modelos/GGUF/
curl -L https://huggingface.co/bartowski/dolphincoder-starcoder2-15b-GGUF/resolve/main/dolphincoder-starcoder2-15b-Q4_K_M.gguf -O
# Servir
  # $HOME/IA/LlamaCPP/llama-server -m $HOME/IA/Modelos/GGUF/dolphincoder-starcoder2-15b-Q4_K_M.gguf --port 9000


# Cyber

  # Lily
    mkdir -p $HOME/IA/Modelos/GGUF/ 2> /dev/null
    cd $HOME/IA/Modelos/GGUF/
    curl -L https://huggingface.co/segolilylabs/Lily-Cybersecurity-7B-v0.2-GGUF/resolve/main/Lily-7B-Instruct-v0.2.Q5_K_M.gguf -O

  # DeepHat
    mkdir -p $HOME/IA/Modelos/GGUF/ 2> /dev/null
    cd $HOME/IA/Modelos/GGUF/
    curl -L https://huggingface.co/mradermacher/DeepHat-V1-7B-GGUF/resolve/main/DeepHat-V1-7B.f16.gguf -O

      https://huggingface.co/Trendyol/Trendyol-Cybersecurity-LLM-v2-70B-Q4_K_M/resolve/main/Llama-3.3-70B-Instruct-Cybersecurity-Q4_K_M.gguf
https://huggingface.co/Trendyol/Trendyol-Cybersecurity-LLM-Qwen3-32B-Q8_0-GGUF/resolve/main/senecallm-x-qwen3-32b-q8_0.gguf
      https://huggingface.co/AlicanKiraz0/Seneca-Cybersecurity-LLM-Q4_K_M-GGUF/resolve/main/senecallm-q4_k_m.gguf

