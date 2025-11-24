#!/bin/bash

# Actualizar la lista de paquetes disponibles en los repositorios
  apt-get -y update

# Instalar requisitos
  apt-get -y install python3
  apt-get -y install python3-venv
  apt-get -y install python3-pip

# Crear el entorno virtual
  python3 -m venv /opt/vllm-venv

# Entrar en el entorno virtual
  source /opt/vllm-venv/bin/activate

# Instalar vllm
  python3 -m pip install vllm --extra-index-url https://download.pytorch.org/whl/cpu

# Arrancar vLLM descarganddo un modelo pequeño para probar que el servidor arranca bien en modo CPU.
  export VLLM_CPU_ONLY=1
  python3 -m vllm.entrypoints.api_server --port 8000 --model google/gemma-3-1b
  python3 -m vllm.entrypoints.api_server --port 8000 --device cpu --model google/gemma-3-1b






# 1- En el servidor maestro
  apt-get -y update
  apt-get -y install python3-venv
  python3 -m venv /opt/vllm-cluster
  source /opt/vllm-cluster/bin/activate
  pip install torch --index-url https://download.pytorch.org/whl/cpu
  pip install ray vllm
  export VLLM_CPU_ONLY=1
  ray start --head \
    --port=6379 \
    --num-cpus=30 \
    --dashboard-host=0.0.0.0

# 2- En cada uno de los otros nodos
  python3 -m venv /opt/vllm-cluster
  source /opt/vllm-cluster/bin/activate
  pip install torch --index-url https://download.pytorch.org/whl/cpu
  pip install ray vllm
  export VLLM_CPU_ONLY=1
  ray start \
    --address='IP_MAESTRO:6379' \
    --num-cpus=30

# 3 - Lanzar en el maestro
  export VLLM_CPU_ONLY=1
  python3 -m vllm.entrypoints.openai.api_server \
    --model meta-llama/Llama-2-13b-chat-hf \
    --tensor-parallel-size 3 \
    --host 0.0.0.0 \
    --port 8000
