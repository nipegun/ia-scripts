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
cd $HOME/IA/Modelos/GGUF/
curl -L https://huggingface.co/segolilylabs/Lily-Cybersecurity-7B-v0.2-GGUF/resolve/main/Lily-7B-Instruct-v0.2.Q5_K_M.gguf -O

https://huggingface.co/Trendyol/Trendyol-Cybersecurity-LLM-v2-70B-Q4_K_M/resolve/main/Llama-3.3-70B-Instruct-Cybersecurity-Q4_K_M.gguf
https://huggingface.co/Trendyol/Trendyol-Cybersecurity-LLM-Qwen3-32B-Q8_0-GGUF/resolve/main/senecallm-x-qwen3-32b-q8_0.gguf
https://huggingface.co/AlicanKiraz0/Seneca-Cybersecurity-LLM-Q4_K_M-GGUF/resolve/main/senecallm-q4_k_m.gguf

curl -L https://huggingface.co/ggml-org/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-mxfp4.gguf -O

curl -L https://huggingface.co/ggml-org/Qwen3-32B-GGUF/resolve/main/Qwen3-32B-Q4_K_M.gguf -O
curl -L https://huggingface.co/ggml-org/Qwen3-32B-GGUF/resolve/main/Qwen3-32B-Q8_0.gguf -O

curl -L https://huggingface.co/ggml-org/Qwen3-14B-GGUF/resolve/main/Qwen3-14B-Q4_K_M.gguf -O
curl -L https://huggingface.co/ggml-org/Qwen3-14B-GGUF/resolve/main/Qwen3-14B-Q8_0.gguf -O
curl -L https://huggingface.co/ggml-org/Qwen3-14B-GGUF/resolve/main/Qwen3-14B-f16.gguf -O


