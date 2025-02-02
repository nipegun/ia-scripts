#!/bin/bash

# Crear carpeta de repos
  mkdir -p ~/repos/ia/

# Borrar versión ya instalada
  rm -rf ~/repos/ia/llama.cpp

# Clonar repositorio
  cd ~/repos/ia/
  git clone https://github.com/ggerganov/llama.cpp.git

# COmpilar
  cd llama.cpp
  mkdir build
  cd build
  # Instalar paquetes necesarios para compilar
    sudo apt -y update
    sudo apt -y install cmake
    sudo apt -y install build-essential
  cmake ..
  cmake --build . --config Release

# Crear carpeta
  mkdir -p ~/Soft/IA/LlamaCPP/
  cp ~/repos/ia/llama.cpp/build/bin/* ~/Soft/IA/LlamaCPP/

# Descargar modelos
  mkdir -p ~/Soft/IA/Modelos/GGUF/
  cd ~/Soft/IA/Modelos/GGUF/
  curl -L https://huggingface.co/lmstudio-community/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q8_0.gguf -O

# Notificar fin de ejecución del script
  echo ""
  echo "  Ejecución del script, finalizada."
  echo ""
  echo "    Para ejecutar llama.cpp y realizar una consulta, cerrando la conversación:"
  echo ""
  echo "      ~/Soft/IA/LlamaCPP/llama-cli -m ~/Soft/IA/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -p 'Hazme un script de python que diga hola?' -no-cnv"
  echo ""
  echo "      Podemos hacer que cierre la conversación, aunque no responda por completo, limitando el nro de tokens de respuesta:"
  echo ""
  echo "        ~/Soft/IA/LlamaCPP/llama-cli -m ~/Soft/IA/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -p 'Hazme un script de python que diga hola?' -n 128 -no-cnv"
  echo ""
  echo "    Para ejecutar en modo conversación:"
  echo ""
  echo "      ~/Soft/IA/LlamaCPP/llama-cli -m ~/Soft/IA/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf"
  echo ""
  echo "    Para ejecutar como API/servidor:"
  echo ""
  echo "      ~/Soft/IA/LlamaCPP/llama-server --port 9000 -m ~/Soft/IA/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf"
  echo ""
  echo "      Crear un servidor para 4 usuarios simultáneos y contexto de 4096 para cada uno:"
  echo ""
  echo "        ~/Soft/IA/LlamaCPP/llama-server --port 9000 -m ~/Soft/IA/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -c 16384 -np 4"
  echo ""
  echo "      Luego podemos tirarle consultas con:"
  echo ""
  echo "        curl -X POST http://localhost:9000/completion -d '{"prompt": "Hola, ¿cómo estás?", "n_predict": 50}'"
  echo ""
