#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar llama.cpp en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/LlamaCPP-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/LlamaCPP-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/LlamaCPP-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install curl
    echo ""
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de llama.cpp para Debian 13 (x)...${cFinColor}"
    echo ""

    # Crear carpeta de Git
      mkdir -p $HOME/Git/ 2> /dev/null

    # Clonar Git
      cd $HOME/Git/
      # Borrar versión ya instalada
        rm -rf $HOME/Git/llama.cpp/
      git clone --depth 1 https://github.com/ggerganov/llama.cpp.git

    # Instalar dependencias para compilar
      sudo apt-get -y update
      sudo apt-get -y install cmake
      sudo apt-get -y install build-essential
      sudo apt-get -y install libcurl4-openssl-dev
      sudo apt-get -y install ccache

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 104 1)
        opciones=(
          1 "Compilar con los valores por defecto"                                                                          off
          2 "Configurar y compilar para uso únicamente con procesador Intel Core i7-7700K"                                  off
          3 "Configurar y compilar para uso únicamente con procesador AMD Ryzen 9 5950x"                                    off
          4 "Configurar y compilar para uso únicamente con procesador AMD Ryzen Threadripper 3970X"                         off
          5 "Configurar y compilar para uso únicamente con procesador AMD Ryzen AI 7 PRO 350"                               off
          
          6 "Configurar y compilar para uso prioritario con CUDA (tarjetas nVidia) y secundario con CPU"                    off
          7 "Configurar y compilar únicamente para uso con CUDA (tarjetas nVidia)"                                          off
          8 "Configurar y compilar para uso prioritario con ROCm (tarjetas AMD) y secundario con CPU"                       off
          9 "Configurar y compilar únicamente para uso con ROCm (tarjetas AMD)"                                             off

         10 "Configurar y compilar para uso prioritario con CUDA (tarjetas nVidia) y secundario con CPU Ryzen 9 5950x"      off
         11 "Configurar y compilar para uso prioritario con CUDA (tarjetas nVidia) y secundario con CPU Ryzen AI 7 PRO 350" off

         20 "Abortar compilación e interrumpir script"                                                                      off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "    Compilando para uso con procesadores genéricos..."
              echo ""
              mkdir $HOME/Git/llama.cpp/build
              cd $HOME/Git/llama.cpp/build
              cmake ..
              cmake --build . --config Release -- -j$(nproc)

            ;;

            2)

              echo ""
              echo "    Compilando para uso con i7-7700K..."
              echo ""
              mkdir $HOME/Git/llama.cpp/build
              cd $HOME/Git/llama.cpp/build
              cmake .. -DCMAKE_CXX_FLAGS="-march=skylake -mtune=skylake -O3"
              cmake --build . --config Release -- -j$(nproc)

            ;;

            3)

              echo ""
              echo "    Compilando para uso con Ryzen 9 5950x..."
              echo ""
              mkdir $HOME/Git/llama.cpp/build
              cd $HOME/Git/llama.cpp/build
              cmake .. -DCMAKE_CXX_FLAGS="-march=znver3 -mtune=znver3 -O3"
              cmake --build . --config Release -- -j$(nproc)

            ;;


            4)

              echo ""
              echo "    Compilando para uso con Ryzen Threadripper 3970X..."
              echo ""
              mkdir $HOME/Git/llama.cpp/build
              cd $HOME/Git/llama.cpp/build
              cmake .. -DCMAKE_CXX_FLAGS="-march=znver2 -mtune=znver2 -O3"
              cmake --build . --config Release -- -j$(nproc)

            ;;

            5)

              echo ""
              echo "    Compilando para uso con Ryzen AI 7 PRO 350..."
              echo ""
              mkdir $HOME/Git/llama.cpp/build
              cd $HOME/Git/llama.cpp/build
              cmake .. -DCMAKE_CXX_FLAGS="-march=znver4 -mtune=znver4 -O3"
              cmake --build . --config Release -- -j$(nproc)

            ;;

            6)

              echo ""
              echo "    Compilando para uso prioritario de CUDA (tarjetas nVidia) y secundario CPU genérico..."
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install -y build-essential cmake libcuda1 libncurses-dev
              mkdir $HOME/Git/llama.cpp/build
              cd $HOME/Git/llama.cpp/build
              cmake .. -DGGML_CUDA=ON -DGGML_CUDA_FORCE=ON -DGGML_NATIVE=ON -DCMAKE_CXX_FLAGS="-O3"
              cmake --build . --config Release -- -j$(nproc)
              # Para limitar la cantidad de memoria VRAM usada, ajusta --n-gpu-layers:
              # Por ejemplo: $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -ngl 100 -n-gpu-layers 32
              # El modelo se cargará 32 capas en VRAM y el resto en RAM 

            ;;

            7)

              echo ""
              echo "    Compilando únicamente para uso con CUDA (tarjetas nVidia)..."
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install -y build-essential cmake libcuda1 libncurses-dev
              mkdir $HOME/Git/llama.cpp/build
              cd $HOME/Git/llama.cpp/build
              cmake .. -DGGML_CUDA=ON -DGGML_CUDA_FORCE=ON -DGGML_CUDA_ONLY=ON -DGGML_NATIVE=ON -DCMAKE_CXX_FLAGS="-O3"
              cmake --build . --config Release -- -j$(nproc)
              # -DGGLM_CUDA=ON: Habilita soporte para CUDA.
              # -DGGML_CUDA_FORCE=ON: Obliga a que se use CUDA, pero todavía permite CPU en caso de error.
              # -DGGML_CUDA_ONLY=ON: Desactiva completamente el uso de CPU, forzando que todo se ejecute en la GPU.
              # -DCMAKE_CXX_FLAGS="-O3": Usa máxima optimización.
              #
              # Si cmake no detecta CUDA, asegúrate de que la variable CUDA_HOME está correctamente configurada:
              # export CUDA_HOME=/usr/local/cuda
              #
              # Para ejecutar: $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -ngl 100
              #   -ngl 100 indica que se usarán todas las capas en la GPU.
              # Si llama.cpp no tiene CPU activada, este comando fallará si la GPU no puede manejar la carga, lo cual confirma que la CPU está deshabilitada.

            ;;

            8)

              echo ""
              echo "    Compilando para uso prioritario de ROCm (tarjetas AMD) y secundario CPU genérico......"
              echo ""
              sudo apt -y update
              sudo apt -y install -y build-essential cmake libcuda1 libncurses-dev
              mkdir $HOME/Git/llama.cpp/build
              cd $HOME/Git/llama.cpp/build
              cmake .. -DGGML_CUDA=ON -DGGML_CUDA_FORCE=ON -DGGML_NATIVE=ON -DCMAKE_CXX_FLAGS="-O3"
              cmake --build . --config Release -- -j$(nproc)
              # Para limitar la cantidad de memoria VRAM usada, ajusta --n-gpu-layers:
              # Por ejemplo: $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -ngl 100 -n-gpu-layers 32
              # El modelo se cargará 32 capas en VRAM y el resto en RAM

            ;;

            9)

              echo ""
              echo "    Compilando únicamente para uso con ROCm (tarjetas AMD)..."
              echo ""
              sudo apt -y update
              sudo apt -y install -y build-essential cmake
              mkdir $HOME/Git/llama.cpp/build
              cd $HOME/Git/llama.cpp/build
              cmake .. -DLLAMA_HIPBLAS=ON -DLLAMA_HIP=ON -DLLAMA_HIP_ONLY=ON -DCMAKE_CXX_FLAGS="-O3"
              cmake --build . --config Release -- -j$(nproc)
              # -DLLAMA_HIPBLAS=ON: Habilita el soporte para HIPBLAS (equivalente a cuBLAS en CUDA).
              # -DLLAMA_HIP=ON: Activa HIP para usar GPU AMD.
              # -DLLAMA_HIP_ONLY=ON: Desactiva la CPU completamente para forzar que solo se use la GPU.
              # -DCMAKE_CXX_FLAGS="-O3": Aplica máxima optimización.
              #
              # Si cmake no detecta HIP, asegúrate de que la variable HIP_PATH está configurada:
              #   export HIP_PATH=/opt/rocm
              #   export PATH=$HIP_PATH/bin:$PATH
              #   export LD_LIBRARY_PATH=$HIP_PATH/lib:$LD_LIBRARY_PATH
              #
              # Para ejecutar: $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -ngl 100
              #   -ngl 100 indica que se usarán todas las capas en la GPU.
              # Si llama.cpp no tiene CPU activada, este comando fallará si la GPU no puede manejar la carga, lo cual confirma que la CPU está deshabilitada.

            ;;

            10)

              echo ""
              echo "    Compilando para uso prioritario de CUDA (tarjetas nVidia) y secundario CPU Ryzen 9 5950x..."
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install -y build-essential cmake libcuda1 libncurses-dev
              mkdir $HOME/Git/llama.cpp/build
              cd $HOME/Git/llama.cpp/build
              cmake .. -DGGML_CUDA=ON -DGGML_CUDA_FORCE=ON -DGGML_NATIVE=ON -DCMAKE_CXX_FLAGS="-march=znver3 -mtune=znver3 -O3"
              cmake --build . --config Release -- -j$(nproc)
              # Para limitar la cantidad de memoria VRAM usada, ajusta --n-gpu-layers:
              # Por ejemplo: $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -ngl 100 -n-gpu-layers 32
              # El modelo se cargará 32 capas en VRAM y el resto en RAM 

            ;;

            11)

              echo ""
              echo "    Compilando para uso prioritario de CUDA (tarjetas nVidia) y secundario CPU Ryzen AI 7 PRO 350..."
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install -y build-essential cmake libcuda1 libncurses-dev
              mkdir $HOME/Git/llama.cpp/build
              cd $HOME/Git/llama.cpp/build
              cmake .. -DGGML_CUDA=ON -DGGML_CUDA_FORCE=ON -DGGML_NATIVE=ON -DCMAKE_CXX_FLAGS="-march=znver4 -mtune=znver4 -O3"
              cmake --build . --config Release -- -j$(nproc)
              # Para limitar la cantidad de memoria VRAM usada, ajusta --n-gpu-layers:
              # Por ejemplo: $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -ngl 100 -n-gpu-layers 32
              # El modelo se cargará 32 capas en VRAM y el resto en RAM 

            ;;

            20)

              echo ""
              echo "    Abortando compilación e interrumpiendo el script..."
              echo ""
              exit

            ;;

        esac

    done

  # Crear carpeta
    mkdir -p $HOME/IA/LlamaCPP/
    cp $HOME/Git/llama.cpp/build/bin/* $HOME/IA/LlamaCPP/

    # Notificar fin de ejecución del script
      echo ""
      echo "  Ejecución del script, finalizada."
      echo ""
      echo "    Para ejecutar llama.cpp y realizar una consulta, cerrando la conversación:"
      echo ""
      echo "      $HOME/IA/LlamaCPP/llama-cli -m $HOME/IA/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -p 'Hazme un script de python que diga hola?' -no-cnv"
      echo ""
      echo "      Podemos hacer que cierre la conversación, aunque no responda por completo, limitando el nro de tokens de respuesta:"
      echo ""
      echo "        $HOME/IA/LlamaCPP/llama-cli -m $HOME/IA/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -p 'Hazme un script de python que diga hola?' -n 128 -no-cnv"
      echo ""
      echo "    Para indicarle cuanta VRAM usar (en el caso de haber compilado con soporte CUDA):"
      echo ""
      echo "      $HOME/IA/LlamaCPP/llama-cli -m $HOME/IA/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -ngl 100 --n-gpu-layers 32"
      echo ""
      echo "        -ngl 100: Usa la GPU completamente."
      echo "        --n-gpu-layers 32: Define cuántas capas del modelo se ejecutarán en la GPU (ajústalo según la VRAM disponible)."
      echo ""
      echo "    Para ejecutar en modo conversación:"
      echo ""
      echo "      $HOME/IA/LlamaCPP/llama-cli -m $HOME/IA/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf"
      echo ""
      echo "    Para ejecutar como API/servidor:"
      echo ""
      echo "      $HOME/IA/LlamaCPP/llama-server --port 9000 -m $HOME/IA/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf"
      echo ""
      echo "      Crear un servidor para 4 usuarios simultáneos y contexto de 4096 para cada uno:"
      echo ""
      echo "        $HOME/IA/LlamaCPP/llama-server --port 9000 -m $HOME/IA/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -c 16384 -np 4"
      echo ""
      echo "      Luego podemos tirarle consultas con:"
      echo ""
      echo "        curl -X POST http://localhost:9000/completion -d '{"prompt": "Hola, ¿cómo estás?", "n_predict": 50}'"
      echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de llama.cpp para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Crear carpeta de Git
      mkdir -p $HOME/Git/

    # Borrar versión ya instalada
      rm -rf $HOME/Git/llama.cpp

    # Clonar Gititorio
      cd $HOME/Git/
      git clone https://github.com/ggerganov/llama.cpp.git

    # Compilar
      cd llama.cpp
      mkdir build
      cd build
      # Instalar paquetes necesarios para compilar
        sudo apt -y update
        sudo apt -y install cmake
        sudo apt -y install build-essential

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 104 1)
        opciones=(
          1 "Compilar con los valores por defecto"                                                       off
          2 "Configurar y compilar para uso únicamente con procesador Intel Core i7-7700K"               off
          3 "Configurar y compilar para uso únicamente con procesador AMD Ryzen 9 5950x"                 off
          4 "Configurar y compilar para uso prioritario con CUDA (tarjetas nVidia) y secundario con CPU" off
          5 "Configurar y compilar únicamente para uso con CUDA (tarjetas nVidia)"                       off
          6 "Configurar y compilar para uso prioritario con ROCm (tarjetas AMD) y secundario con CPU"    off
          7 "Configurar y compilar únicamente para uso con ROCm (tarjetas AMD)"                          off
          8 "Abortar compilación e interrumpir script"                                                   off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "    Compilando para uso con procesadores genéricos..."
              echo ""
              cd $HOME/Git/llama.cpp/build
              cmake ..
              cmake --build . --config Release -- -j$(nproc)

            ;;

            2)

              echo ""
              echo "    Compilando para uso con i7-7700K..."
              echo ""
              cd $HOME/Git/llama.cpp/build
              cmake .. -DCMAKE_CXX_FLAGS="-march=skylake -mtune=skylake -O3"
              cmake --build . --config Release -- -j$(nproc)

            ;;

            3)

              echo ""
              echo "    Compilando para uso con Ryzen 9 5950x..."
              echo ""
              cd $HOME/Git/llama.cpp/build
              cmake .. -DCMAKE_CXX_FLAGS="-march=znver3 -mtune=znver3 -O3"
              cmake --build . --config Release -- -j$(nproc)

            ;;

            4)

              echo ""
              echo "    Compilando para uso prioritario de CUDA (tarjetas nVidia) y secundario CPU genérico..."
              echo ""
              sudo apt -y update
              sudo apt -y install -y build-essential cmake libcuda1 libncurses-dev
              cd $HOME/Git/llama.cpp/build
              cmake .. -DLLAMA_CUDA=ON -DLLAMA_CUDA_FORCE=ON -DLLAMA_NATIVE=ON -DCMAKE_CXX_FLAGS="-O3"
              cmake --build . --config Release -- -j$(nproc)
              # Para limitar la cantidad de memoria VRAM usada, ajusta --n-gpu-layers:
              # Por ejemplo: $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -ngl 100 -n-gpu-layers 32
              # El modelo se cargará 32 capas en VRAM y el resto en RAM 

            ;;

            5)

              echo ""
              echo "    Compilando únicamente para uso con CUDA (tarjetas nVidia)..."
              echo ""
              sudo apt -y update
              sudo apt -y install -y build-essential cmake libcuda1 libncurses-dev
              cd $HOME/Git/llama.cpp/build
              cmake .. -DLLAMA_CUDA=ON -DLLAMA_CUDA_FORCE=ON -DLLAMA_CUDA_ONLY=ON -DCMAKE_CXX_FLAGS="-O3"
              cmake --build . --config Release -- -j$(nproc)
              # -DLLAMA_CUDA=ON: Habilita soporte para CUDA.
              # -DLLAMA_CUDA_FORCE=ON: Obliga a que se use CUDA, pero todavía permite CPU en caso de error.
              # -DLLAMA_CUDA_ONLY=ON: Desactiva completamente el uso de CPU, forzando que todo se ejecute en la GPU.
              # -DCMAKE_CXX_FLAGS="-O3": Usa máxima optimización.
              #
              # Si cmake no detecta CUDA, asegúrate de que la variable CUDA_HOME está correctamente configurada:
              # export CUDA_HOME=/usr/local/cuda
              #
              # Para ejecutar: $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -ngl 100
              #   -ngl 100 indica que se usarán todas las capas en la GPU.
              # Si llama.cpp no tiene CPU activada, este comando fallará si la GPU no puede manejar la carga, lo cual confirma que la CPU está deshabilitada.

            ;;

            6)

              echo ""
              echo "    Compilando para uso prioritario de ROCm (tarjetas AMD) y secundario CPU genérico......"
              echo ""
              sudo apt -y update
              sudo apt -y install -y build-essential cmake libcuda1 libncurses-dev
              cd $HOME/Git/llama.cpp/build
              cmake .. -DLLAMA_CUDA=ON -DLLAMA_CUDA_FORCE=ON -DLLAMA_NATIVE=ON -DCMAKE_CXX_FLAGS="-O3"
              cmake --build . --config Release -- -j$(nproc)
              # Para limitar la cantidad de memoria VRAM usada, ajusta --n-gpu-layers:
              # Por ejemplo: $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -ngl 100 -n-gpu-layers 32
              # El modelo se cargará 32 capas en VRAM y el resto en RAM

            ;;

            7)

              echo ""
              echo "    Compilando únicamente para uso con ROCm (tarjetas AMD)..."
              echo ""
              sudo apt -y update
              sudo apt -y install -y build-essential cmake
              cd $HOME/Git/llama.cpp/build
              cmake .. -DLLAMA_HIPBLAS=ON -DLLAMA_HIP=ON -DLLAMA_HIP_ONLY=ON -DCMAKE_CXX_FLAGS="-O3"
              cmake --build . --config Release -- -j$(nproc)
              # -DLLAMA_HIPBLAS=ON: Habilita el soporte para HIPBLAS (equivalente a cuBLAS en CUDA).
              # -DLLAMA_HIP=ON: Activa HIP para usar GPU AMD.
              # -DLLAMA_HIP_ONLY=ON: Desactiva la CPU completamente para forzar que solo se use la GPU.
              # -DCMAKE_CXX_FLAGS="-O3": Aplica máxima optimización.
              #
              # Si cmake no detecta HIP, asegúrate de que la variable HIP_PATH está configurada:
              #   export HIP_PATH=/opt/rocm
              #   export PATH=$HIP_PATH/bin:$PATH
              #   export LD_LIBRARY_PATH=$HIP_PATH/lib:$LD_LIBRARY_PATH
              #
              # Para ejecutar: $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -ngl 100
              #   -ngl 100 indica que se usarán todas las capas en la GPU.
              # Si llama.cpp no tiene CPU activada, este comando fallará si la GPU no puede manejar la carga, lo cual confirma que la CPU está deshabilitada.

            ;;

            8)

              echo ""
              echo "    Abortando compilación e interrumpiendo el script..."
              echo ""
              exit

            ;;

        esac

    done

    # Crear carpeta
      mkdir -p $HOME/LlamaCPP/
      cp $HOME/Git/llama.cpp/build/bin/* $HOME/LlamaCPP/

    # Descargar modelos
      mkdir -p $HOME/Modelos/GGUF/
      cd $HOME/Modelos/GGUF/
      curl -L https://huggingface.co/lmstudio-community/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q8_0.gguf -O

    # Notificar fin de ejecución del script
      echo ""
      echo "  Ejecución del script, finalizada."
      echo ""
      echo "    Para ejecutar llama.cpp y realizar una consulta, cerrando la conversación:"
      echo ""
      echo "      $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -p 'Hazme un script de python que diga hola?' -no-cnv"
      echo ""
      echo "      Podemos hacer que cierre la conversación, aunque no responda por completo, limitando el nro de tokens de respuesta:"
      echo ""
      echo "        $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -p 'Hazme un script de python que diga hola?' -n 128 -no-cnv"
      echo ""
      echo "    Para indicarle cuanta VRAM usar (en el caso de haber compilado con soporte CUDA):"
      echo ""
      echo "      $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -ngl 100 --n-gpu-layers 32"
      echo ""
      echo "        -ngl 100: Usa la GPU completamente."
      echo "        --n-gpu-layers 32: Define cuántas capas del modelo se ejecutarán en la GPU (ajústalo según la VRAM disponible)."
      echo ""
      echo "    Para ejecutar en modo conversación:"
      echo ""
      echo "      $HOME/LlamaCPP/llama-cli -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf"
      echo ""
      echo "    Para ejecutar como API/servidor:"
      echo ""
      echo "      $HOME/LlamaCPP/llama-server --port 9000 -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf"
      echo ""
      echo "      Crear un servidor para 4 usuarios simultáneos y contexto de 4096 para cada uno:"
      echo ""
      echo "        $HOME/LlamaCPP/llama-server --port 9000 -m $HOME/Modelos/GGUF/Llama-3.2-3B-Instruct-Q8_0.gguf -c 16384 -np 4"
      echo ""
      echo "      Luego podemos tirarle consultas con:"
      echo ""
      echo "        curl -X POST http://localhost:9000/completion -d '{"prompt": "Hola, ¿cómo estás?", "n_predict": 50}'"
      echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de llama.cpp para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de llama.cpp para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de llama.cpp para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de llama.cpp para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de llama.cpp para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
