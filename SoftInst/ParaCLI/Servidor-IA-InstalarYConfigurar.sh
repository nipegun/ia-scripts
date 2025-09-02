#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar un servidor de inteligencia artificial en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Servidor-IA-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Servidor-IA-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
# ----------

# Indicar cuál es el usuario no root
  vUsuarioNoRoot="usuariox"

# -------------------------
# NO TOCAR A PARTIR DE AQUÍ
# -------------------------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

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

if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 13 (x)...${cFinColor}"
  echo ""

  vFechaDeEjec=$(date +a%Ym%md%d@%T)

  # Crear el menú
    # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        sudo apt-get -y update
        sudo apt-get -y install dialog
        echo ""
      fi
    menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      opciones=(
        1 "Instalar Ollama"                                  on
        2 "  Instalar Open WebUI"                            on
        3 "  Instalar modelos LLM para Ollama"               on
        4 "Instalar TextGeneration WebUI"                    off
        5 "  Instalar modelos LLM para TextGeneration WebUI" off
        6 "Instalar LMStudio"                                off
        7 "  Instalar modelos LLM para LMStudio"             off
        8 "Instalar AnythingLLM"                             off
        9 "Instalar FlowiseAI"                               on
       10 "Instalar LibreChat"                               off
       11 "Instalar LiteLLM"                                 off 
      )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    echo ""

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando Ollama..."
            echo ""

            echo ""
            echo "    Bajando y ejecutando el script de instalación desde la web oficial..."
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                echo ""
              fi
            # Comprobar si el paquete pciutils está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s pciutils 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}      El paquete pciutils no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install pciutils
                echo ""
              fi
            # Correr el script de instalación
              curl -sL https://ollama.com/install.sh | sudo bash

            # Permitir las conexiones desde fuera
              # Meter Environment="OLLAMA_HOST=0.0.0.0:11434" antes de [Install] en /etc/systemd/system/ollama.service

            # Activar e iniciar el servicio
              sudo systemctl enable ollama --now

            # Notificar fin de la instalación
              echo ""
              echo "  Instalación finalizada."
              echo ""
              echo "    Para enviar peticiones a la API:"
              echo "      curl http://localhost:11434/api/generate -d '{ "'"model"'": "'"llama3.1:8b-instruct-fp16"'", "'"prompt"'": "'"Hola. Qué tal?"'", "'"stream"'": false }'"
              echo '        o'
              echo "      curl http://127.0.0.1:11434/api/generate -d '{ "'"model"'": "'"mistral:7b"'", "'"prompt"'": "'"Hola. Qué tal?"'", "'"stream"'": false, "'"temperature"'": 0.3, "'"max_length"'": 80}'"
              echo ''
              echo "      Ollama tiene una interfaz de texto. Si quieres interfaz web, instala Open WebUI o alguna similar."
              echo ""

          ;;

          2)

            echo ""
            echo "  Instalando Open WebUI..."
            echo ""
            sudo apt-get -y update
            sudo apt-get -y install python3-venv
            sudo python3 -m venv --system-site-packages /opt/open-webui
            sudo /opt/open-webui/bin/pip3 install open-webui

            # Crear el servicio
              echo ""
              echo "  Creando el servicio..."
              echo ""
              echo "[Unit]"                                         | sudo tee    /usr/lib/systemd/system/open-webui.service
              echo "Description=Open WebUI Service"                 | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "After=network.target"                           | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo ""                                               | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "[Service]"                                      | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "Type=simple"                                    | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "ExecStart=/opt/open-webui/bin/open-webui serve" | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo 'ExecStop=/bin/kill -HUP $MAINPID'               | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "User=root"                                      | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "Group=root"                                     | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo ""                                               | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "[Install]"                                      | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "WantedBy=multi-user.target"                     | sudo tee -a /usr/lib/systemd/system/open-webui.service

            # Activar e iniciar el servicio
              echo ""
              echo "  Activando e iniciando el servicio..."
              echo ""
              sudo systemctl daemon-reload
              sudo systemctl enable --now open-webui.service 

            # Notificar fin de la instalación de Open WebUI
              echo ""
              echo "  Instalación de Open WebUI, finalizada."
              echo ""
              echo "    La web está disponible en: http://localhost:8080"
              echo ""
              echo "    El primer usuario en registrarse se convertirá automáticamente en el Administrador."
              echo ""

          ;;

          3)

            echo ""
            echo "  Instalando modelos LLM para Ollama..."
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                echo ""
              fi
             curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Ollama-Modelos-Instalar-LLM.sh | bash

          ;;

          4)

            echo ""
            echo "  Instalando TextGeneration WebUI..."
            echo ""

            # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install wget
                echo ""
              fi

            # Comprobar si hay conexión a Internet antes de sincronizar los d-scripts
              wget -q --tries=10 --timeout=20 --spider https://github.com
              if [[ $? -eq 0 ]]; then
                # Borrar carpeta vieja
                  rm $HOME/IA/text-generation-webui -R 2> /dev/null
                  mkdir $HOME/IA/ 2> /dev/null
                  cd $HOME/IA/
                # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}    El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install git
                    echo ""
                  fi
                git clone --depth=1 https://github.com/oobabooga/text-generation-webui
                find $HOME/IA/text-generation-webui/ -type f -iname "*.sh" -exec chmod +x {} \;
                sudo mv $HOME/IA/text-generation-webui/ /opt
              fi

            # Instalar ROCm SDK 6.1 (Para tarjetas AMD a partir de Radeon RX 6800 XT)

            # Crear el servicio
              echo ""
              echo "  Creando el servicio..."
              echo ""
              echo "[Unit]"                                                       | sudo tee    /usr/lib/systemd/system/text-generation-webui.service
              echo "Description=TextGeneration WebUI Service"                     | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "After=network.target"                                         | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo ""                                                             | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "[Service]"                                                    | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "Type=simple"                                                  | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "ExecStart=/opt/text-generation-webui/start_linux.sh --listen" | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "ExecStop=/bin/kill -HUP $MAINPID"                             | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "User=root"                                                    | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "Group=root"                                                   | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo ""                                                             | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "[Install]"                                                    | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "WantedBy=multi-user.target"                                   | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service

            # Activar e iniciar el servicio
              echo ""
              echo "  Activando e iniciando el servicio..."
              echo ""
              systemctl daemon-reload

            # Notificar fin de la instalación
              echo ""
              echo "  Instalación de TextGeneration WebUI, finalizada."
              echo ""
              echo "    Auto-ejecutando..."
              echo "      Para salir, presiona Ctrl+c"
              echo ""
              echo "    Para volver a iniciar, ejecuta:"
              echo "      /opt/text-generation-webui/start_linux.sh"
              echo ""
              echo "    Si quieres que se escuche en todas las IPs (no sólo en localhost), ejecuta:"
              echo "      /opt/text-generation-webui/start_linux.sh --listen"
              echo ""
              echo "    Para actualizar TextGeneration WebUI, ejecuta:"
              echo "      /root/SoftInst/text-generation-webui/update_wizard_linux.sh"
              echo ""
              echo "    Se ha creado el servicio. Para activarlo, ejecuta:"
              echo "      systemctl enable --now text-generation-webui.service"
              echo ""

            # Instalar el paquete e iniciar
              chmod +x /opt/text-generation-webui/start_linux.sh
              /opt/text-generation-webui/start_linux.sh

          ;;

          5)

            echo ""
            echo "  Instalando modelos LLM para TextGeneration WebUI..."
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                echo ""
              fi
            curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/TextGenerationWebUI-Modelos-Instalar-LLM.sh | bash

          ;;

          6)

            echo ""
            echo "  Instalando LM Studio.."
            echo ""
            # Obtener el enlace de descarga
              #vEnlace=$(curl -sL )
              vEnlaceAppImage=$(curl -sL https://lmstudio.ai/ | sed 's->->\n-g' | sed 's-http-\nhttp-g' | sed 's-AppImage-AppImage\n-g' | grep -v win32|  grep staller | grep linux | grep x64 | head -n1)
            echo ""
            echo "    Descargando paquete AppImage..."
            echo ""
            curl -L -o /tmp/LMStudio.AppImage $vEnlaceAppImage
            chmod +x /tmp/LMStudio.AppImage
            mkdir -p /home/$USER/IA/LMStudio 2> /dev/null
            mv /tmp/LMStudio.AppImage /home/$USER/IA/LMStudio
            chown $USER:$USER /home/$USER/IA/ -R

            # Notificar fin de la instalación
              echo ""
              echo "    La instalación de LMStudio ha finalizado. Para lanzarlo, ejecuta:"
              echo ""
              echo "      /home/$USER/IA/LMStudio/LMStudio.AppImage"
              echo ""

          ;;

          7)

            echo ""
            echo "  Instalando modelos LLM para LMStudio.."
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                echo ""
              fi
            curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/LMStudio-Modelos-Instalar-LLM.sh | bash

          ;;

          8)

            echo ""
            echo "  Instalando AnythingLLM.."
            echo ""

          ;;

          9)

            echo ""
            echo "  Instalando FlowiseAI..."
            echo ""

            # Instalar Node.js
              echo ""
              echo "    Instalando Node.js..."
              echo ""
              # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install curl
                  echo ""
                fi
              curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Node.js-InstalarYConfigurar.sh | sudo bash

            # Instalar FlowiseAI con NPM
              echo ""
              echo "    Continuando con la instalación de FlowiseAI..."
              echo ""
              # Hacer la instalación global (-g) en la carpeta /opt/flowise/
                sudo npm install --prefix /opt/flowise/ -g flowise@latest
                sudo npm install --prefix /opt/flowise/ -g turndown
                sudo npm install --prefix /opt/flowise/ -g @opentelemetry/exporter-trace-otlp-grpc
                sudo npm install --prefix /opt/flowise/ -g @opentelemetry/exporter-trace-otlp-proto
                sudo npm install --prefix /opt/flowise/ -g @opentelemetry/sdk-trace-node
                sudo npm install --prefix /opt/flowise/ -g langchainhub
                sudo npm install --prefix /opt/flowise/ -g @langchain/community


            # Agregar el usuario flowise
              echo ""
              echo "    Agregando el usuario y grupo flowise..."
              echo ""
              sudo mkdir -p /opt/flowise/ 2> /dev/null
              sudo useradd -d /opt/flowise/ -s /bin/false flowise
              sudo chown flowise:flowise /opt/flowise -R 2> /dev/null

            # Crear el servicio de systemd para flowiseai
              echo "[Unit]"                                   | sudo tee    /etc/systemd/system/flowise.service
              echo "Description=FlowiseAI"                    | sudo tee -a /etc/systemd/system/flowise.service
              echo "After=network.target"                     | sudo tee -a /etc/systemd/system/flowise.service
              echo ""                                         | sudo tee -a /etc/systemd/system/flowise.service
              echo "[Service]"                                | sudo tee -a /etc/systemd/system/flowise.service
              echo "Type=notify"                              | sudo tee -a /etc/systemd/system/flowise.service
              echo "ExecStart=/opt/flowise/bin/flowise start" | sudo tee -a /etc/systemd/system/flowise.service
              echo "WorkingDirectory=/opt/flowise"            | sudo tee -a /etc/systemd/system/flowise.service
              echo "Restart=always"                           | sudo tee -a /etc/systemd/system/flowise.service
              echo "User=flowise"                             | sudo tee -a /etc/systemd/system/flowise.service
              echo "Group=flowise"                            | sudo tee -a /etc/systemd/system/flowise.service
              echo ""                                         | sudo tee -a /etc/systemd/system/flowise.service
              echo "[Install]"                                | sudo tee -a /etc/systemd/system/flowise.service
              echo "WantedBy=multi-user.target"               | sudo tee -a /etc/systemd/system/flowise.service

            # Activar e iniciar el servicio
              sudo systemctl daemon-reload
              sudo systemctl enable flowise.service
              sudo systemctl start flowise.service

            # Notificar fin de instalación
              echo ""
              echo "      Flowise se ha instalado. Deberías poder acceder a la web aquí:"
              echo "        http://localhost:3000"
              echo "          Usuario: $vUsuarioWebFlowise"
              echo "          Contraseña: $vContraWebFlowise"
              echo ""
              echo "        Si quieres usar otro usuario y contraseña, módifícalos aquí:"
              echo "          /etc/systemd/system/flowise.service"
              echo "        ...y ejecuta:"
              echo "          systemctl stop flowise.service && systemctl daemon-reload && systemctl start flowise.service"
              echo ""
              echo "        Si no funciona el servicio, es posible lanzar Flowise desde la línea de comandos, ejecutando como root:"
              echo "          su - flowise -c '/opt/flowise/bin/flowise start'"
              echo "            o, para tener usuario y contraseña:"
              echo "          su - flowise -c '/opt/flowise/bin/flowise start --FLOWISE_USERNAME=$vUsuarioWebFlowise --FLOWISE_PASSWORD=$vContraWebFlowise'"
              echo ""
              echo "        Es posible asegurar un ChatFlow con una API key. Mas info en:"
              echo "          https://docs.flowiseai.com/configuration/authorization/chatflow-level"
              echo ""

          ;;

         10)

            echo ""
            echo "  Instalando LibreChat..."
            echo ""

            # Instalar Node.js
              echo ""
              echo "    Instalando Node.js..."
              echo ""
              # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install curl
                  echo ""
                fi
              curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Node.js-InstalarYConfigurar.sh | sudo bash

            # Instalar MongoDB
              echo ""
              echo "    Instalando MongoDB..."
              echo ""
              curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-MongoDB-Instalar.sh | sudo bash

            # Clonar repositorio
              mkdir -p $HOME/IA/ 2> /dev/null
              rm -rf $HOME/IA/LibreChat/
              cd $HOME/IA/
              # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install git
                  echo ""
                fi
              git clone https://github.com/danny-avila/LibreChat.git

            # Preparar carpeta final
              sudo mv $HOME/IA/LibreChat/ /opt/
              sudo mv /opt/LibreChat/ /opt/librechat/

            # Compilar
              cd /opt/librechat/
              cp .env.example .env
              # Modificar la URL de la base de datos
                #sed -i -e 's|MONGO_URI=mongodb://127.0.0.1:27017/LibreChat|MONGO_URI=mongodb://127.0.0.1:27017/LibreChat|g' /root/SoftInst/LibreChat/.env
              # Instalar dependencias
                npm ci
              # Construir el frontend
                npm run frontend
              # Especificar el directorio de datos donde MongoDB guardará los archivos
                mkdir -p /opt/librechat/mongodb/
                sudo chown mongodb:mongodb /opt/librechat/mongodb/
                cd /usr/bin
                sudo ./mongod --dbpath=/opt/librechat/mongodb

            # Agregar ollama como endpoint
              cd /opt/librechat/
              cp librechat.example.yaml librechat.yaml
              sed -i '/endpoints:/,$d' librechat.yaml
              echo 'endpoints:'                                                      >> librechat.yaml
              echo '  custom:'                                                       >> librechat.yaml
              echo '    - name: "Ollama"'                                            >> librechat.yaml
              echo '      apiKey: "ollama"'                                          >> librechat.yaml
              echo '      baseURL: "http://127.0.0.1:11434/v1/chat/completions"'     >> librechat.yaml
              echo '      models:'                                                   >> librechat.yaml
              echo '        default: ['                                              >> librechat.yaml
              echo '          "llama3:8b",'                                          >> librechat.yaml
              echo '          "llama3:70b"'                                          >> librechat.yaml
              echo '          ]'                                                     >> librechat.yaml
              echo '        fetch: false # fetching list of models is not supported' >> librechat.yaml
              echo '      titleConvo: true'                                          >> librechat.yaml
              echo '      titleModel: "current_model"'                               >> librechat.yaml
              echo '      summarize: false'                                          >> librechat.yaml
              echo '      summaryModel: "current_model"'                             >> librechat.yaml
              echo '      forcePrompt: false'                                        >> librechat.yaml
              echo '      modelDisplayLabel: "Ollama"'                               >> librechat.yaml
              echo '      addParams:'                                                >> librechat.yaml
              echo '            "stop": ['                                           >> librechat.yaml
              echo '              "<|start_header_id|>",'                            >> librechat.yaml
              echo '              "<|end_header_id|>",'                              >> librechat.yaml
              echo '              "<|eot_id|>",'                                     >> librechat.yaml
              echo '              "<|reserved_special_token"'                        >> librechat.yaml
              echo '            ]'                                                   >> librechat.yaml

            # Notificar fin de la instalación
              echo ""
              echo "      La instalación de LibreChat ha finalizado."
              echo ""
              echo "        Para poner tu OPENAI_API_KEY edita: /opt/librechat/.env"
              echo ""
              echo "        Para iniciar el servidor, ejecuta:"
              echo "          cd /opt/librechat/ && npm run backend"
              echo ""
              echo "        Para actualizar LibreChat, ejecuta:"
              echo "          cd /opt/librechat/ && npm ci && npm run frontend"
              echo ""
              echo "        Una vez iniciado el servidor podrás acceder a él en:"
              echo "          http://localhost:3080"
              echo ""

          ;;

         11)

            echo ""
            echo "  Instalando LiteLLM (Proxy)..."
            echo ""

          ;;

      esac

  done

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  vFechaDeEjec=$(date +a%Ym%md%d@%T)

  # Crear el menú
    # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        sudo apt-get -y update
        sudo apt-get -y install dialog
        echo ""
      fi
    menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      opciones=(
        1 "Instalar Ollama"                                  on
        2 "  Instalar Open WebUI"                            on
        3 "  Instalar modelos LLM para Ollama"               on
        4 "Instalar TextGeneration WebUI"                    off
        5 "  Instalar modelos LLM para TextGeneration WebUI" off
        6 "Instalar LMStudio"                                off
        7 "  Instalar modelos LLM para LMStudio"             off
        8 "Instalar AnythingLLM"                             off
        9 "Instalar FlowiseAI"                               on
       10 "Instalar LibreChat"                               off
       11 "Instalar LiteLLM"                                 off 
      )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    echo ""

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando Ollama..."
            echo ""

            echo ""
            echo "    Bajando y ejecutando el script de instalación desde la web oficial..."
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                echo ""
              fi
            # Comprobar si el paquete pciutils está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s pciutils 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}      El paquete pciutils no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install pciutils
                echo ""
              fi
            # Correr el script de instalación
              curl -sL https://ollama.com/install.sh | sudo bash

            # Permitir las conexiones desde fuera
              # Meter Environment="OLLAMA_HOST=0.0.0.0:11434" antes de [Install] en /etc/systemd/system/ollama.service

            # Activar e iniciar el servicio
              sudo systemctl enable ollama --now

            # Notificar fin de la instalación
              echo ""
              echo "  Instalación finalizada."
              echo ""
              echo "    Para enviar peticiones a la API:"
              echo "      curl http://localhost:11434/api/generate -d '{ "'"model"'": "'"llama3.1:8b-instruct-fp16"'", "'"prompt"'": "'"Hola. Qué tal?"'", "'"stream"'": false }'"
              echo '        o'
              echo "      curl http://127.0.0.1:11434/api/generate -d '{ "'"model"'": "'"mistral:7b"'", "'"prompt"'": "'"Hola. Qué tal?"'", "'"stream"'": false, "'"temperature"'": 0.3, "'"max_length"'": 80}'"
              echo ''
              echo "      Ollama tiene una interfaz de texto. Si quieres interfaz web, instala Open WebUI o alguna similar."
              echo ""

          ;;

          2)

            echo ""
            echo "  Instalando Open WebUI..."
            echo ""
            sudo apt-get -y update
            sudo apt-get -y install python3-venv
            sudo python3 -m venv --system-site-packages /opt/open-webui
            sudo /opt/open-webui/bin/pip3 install open-webui

            # Crear el servicio
              echo ""
              echo "  Creando el servicio..."
              echo ""
              echo "[Unit]"                                         | sudo tee    /usr/lib/systemd/system/open-webui.service
              echo "Description=Open WebUI Service"                 | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "After=network.target"                           | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo ""                                               | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "[Service]"                                      | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "Type=simple"                                    | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "ExecStart=/opt/open-webui/bin/open-webui serve" | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo 'ExecStop=/bin/kill -HUP $MAINPID'               | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "User=root"                                      | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "Group=root"                                     | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo ""                                               | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "[Install]"                                      | sudo tee -a /usr/lib/systemd/system/open-webui.service
              echo "WantedBy=multi-user.target"                     | sudo tee -a /usr/lib/systemd/system/open-webui.service

            # Activar e iniciar el servicio
              echo ""
              echo "  Activando e iniciando el servicio..."
              echo ""
              sudo systemctl daemon-reload
              sudo systemctl enable --now open-webui.service 

            # Notificar fin de la instalación de Open WebUI
              echo ""
              echo "  Instalación de Open WebUI, finalizada."
              echo ""
              echo "    La web está disponible en: http://localhost:8080"
              echo ""
              echo "    El primer usuario en registrarse se convertirá automáticamente en el Administrador."
              echo ""

          ;;

          3)

            echo ""
            echo "  Instalando modelos LLM para Ollama..."
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                echo ""
              fi
             curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/Ollama-Modelos-Instalar-LLM.sh | bash

          ;;

          4)

            echo ""
            echo "  Instalando TextGeneration WebUI..."
            echo ""

            # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install wget
                echo ""
              fi

            # Comprobar si hay conexión a Internet antes de sincronizar los d-scripts
              wget -q --tries=10 --timeout=20 --spider https://github.com
              if [[ $? -eq 0 ]]; then
                # Borrar carpeta vieja
                  rm $HOME/IA/text-generation-webui -R 2> /dev/null
                  mkdir $HOME/IA/ 2> /dev/null
                  cd $HOME/IA/
                # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}    El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install git
                    echo ""
                  fi
                git clone --depth=1 https://github.com/oobabooga/text-generation-webui
                find $HOME/IA/text-generation-webui/ -type f -iname "*.sh" -exec chmod +x {} \;
                sudo mv $HOME/IA/text-generation-webui/ /opt
              fi

            # Instalar ROCm SDK 6.1 (Para tarjetas AMD a partir de Radeon RX 6800 XT)

            # Instalar el paquete
              chmod +x /opt/text-generation-webui/start_linux.sh
              /opt/text-generation-webui/start_linux.sh

            # Crear el servicio
              echo ""
              echo "  Creando el servicio..."
              echo ""
              echo "[Unit]"                                                       | sudo tee    /usr/lib/systemd/system/text-generation-webui.service
              echo "Description=TextGeneration WebUI Service"                     | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "After=network.target"                                         | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo ""                                                             | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "[Service]"                                                    | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "Type=simple"                                                  | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "ExecStart=/opt/text-generation-webui/start_linux.sh --listen" | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "ExecStop=/bin/kill -HUP $MAINPID"                             | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "User=root"                                                    | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "Group=root"                                                   | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo ""                                                             | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "[Install]"                                                    | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service
              echo "WantedBy=multi-user.target"                                   | sudo tee -a /usr/lib/systemd/system/text-generation-webui.service

            # Activar e iniciar el servicio
              echo ""
              echo "  Activando e iniciando el servicio..."
              echo ""
              systemctl daemon-reload

            # Notificar fin de la instalación
              echo ""
              echo "  Instalación de TextGeneration WebUI, finalizada."
              echo ""
              echo "    Auto-ejecutando..."
              echo "      Para salir, presiona Ctrl+c"
              echo ""
              echo "    Para volver a iniciar, ejecuta:"
              echo "      /opt/text-generation-webui/start_linux.sh"
              echo ""
              echo "    Si quieres que se escuche en todas las IPs (no sólo en localhost), ejecuta:"
              echo "      /opt/text-generation-webui/start_linux.sh --listen"
              echo ""
              echo "    Para actualizar TextGeneration WebUI, ejecuta:"
              echo "      /root/SoftInst/text-generation-webui/update_wizard_linux.sh"
              echo ""
              echo "    Se ha creado el servicio. Para activarlo, ejecuta:"
              echo "      systemctl enable --now text-generation-webui.service"
              echo ""

          ;;

          5)

            echo ""
            echo "  Instalando modelos LLM para TextGeneration WebUI..."
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                echo ""
              fi
            curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/TextGenerationWebUI-Modelos-Instalar-LLM.sh | bash

          ;;

          6)

            echo ""
            echo "  Instalando LM Studio.."
            echo ""
            # Obtener el enlace de descarga
              #vEnlace=$(curl -sL )
              vEnlace="https://installers.lmstudio.ai/linux/x64/0.3.8-4/LM-Studio-0.3.8-4-x64.AppImage"
            echo ""
            echo "    Descargando paquete AppImage..."
            echo ""
            curl -L -o /tmp/LMStudio.AppImage $vEnlace
            chmod +x /tmp/LMStudio.AppImage
            mkdir -p /home/$USER/IA/LMStudio 2> /dev/null
            mv /tmp/LMStudio.AppImage /home/$USER/IA/LMStudio
            chown $USER:$USER /home/$USER/IA/ -R

            # Notificar fin de la instalación
              echo ""
              echo "    La instalación de LMStudio ha finalizado. Para lanzarlo, ejecuta:"
              echo ""
              echo "      /home/$USER/IA/LMStudio/LMStudio.AppImage"
              echo ""

          ;;

          7)

            echo ""
            echo "  Instalando modelos LLM para LMStudio.."
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                echo ""
              fi
            curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/SoftInst/ParaCLI/LMStudio-Modelos-Instalar-LLM.sh | bash

          ;;

          8)

            echo ""
            echo "  Instalando AnythingLLM.."
            echo ""

          ;;

          9)

            echo ""
            echo "  Instalando FlowiseAI..."
            echo ""

            # Instalar Node.js
              echo ""
              echo "    Instalando Node.js..."
              echo ""
              # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install curl
                  echo ""
                fi
              curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Node.js-InstalarYConfigurar.sh | sudo bash

            # Instalar FlowiseAI con NPM
              echo ""
              echo "    Continuando con la instalación de FlowiseAI..."
              echo ""
              # Hacer la instalación global (-g) en la carpeta /opt/flowise/
                sudo npm install --prefix /opt/flowise/ -g flowise@latest
                sudo npm install --prefix /opt/flowise/ -g turndown
                sudo npm install --prefix /opt/flowise/ -g @opentelemetry/exporter-trace-otlp-grpc
                sudo npm install --prefix /opt/flowise/ -g @opentelemetry/exporter-trace-otlp-proto
                sudo npm install --prefix /opt/flowise/ -g @opentelemetry/sdk-trace-node
                sudo npm install --prefix /opt/flowise/ -g langchainhub
                sudo npm install --prefix /opt/flowise/ -g @langchain/community


            # Agregar el usuario mattermost
              echo ""
              echo "    Agregando el usuario y grupo flowise..."
              echo ""
              sudo mkdir -p /opt/flowise/ 2> /dev/null
              sudo useradd -d /opt/flowise/ -s /bin/false flowise
              sudo chown flowise:flowise /opt/flowise -Rv 2> /dev/null

            # Crear el servicio de systemd para flowiseai
              echo "[Unit]"                                   | sudo tee    /etc/systemd/system/flowise.service
              echo "Description=FlowiseAI"                    | sudo tee -a /etc/systemd/system/flowise.service
              echo "After=network.target"                     | sudo tee -a /etc/systemd/system/flowise.service
              echo ""                                         | sudo tee -a /etc/systemd/system/flowise.service
              echo "[Service]"                                | sudo tee -a /etc/systemd/system/flowise.service
              echo "Type=notify"                              | sudo tee -a /etc/systemd/system/flowise.service
              echo "ExecStart=/opt/flowise/bin/flowise start" | sudo tee -a /etc/systemd/system/flowise.service
              echo "WorkingDirectory=/opt/flowise"            | sudo tee -a /etc/systemd/system/flowise.service
              echo "Restart=always"                           | sudo tee -a /etc/systemd/system/flowise.service
              echo "User=flowise"                             | sudo tee -a /etc/systemd/system/flowise.service
              echo "Group=flowise"                            | sudo tee -a /etc/systemd/system/flowise.service
              echo ""                                         | sudo tee -a /etc/systemd/system/flowise.service
              echo "[Install]"                                | sudo tee -a /etc/systemd/system/flowise.service
              echo "WantedBy=multi-user.target"               | sudo tee -a /etc/systemd/system/flowise.service

            # Activar e iniciar el servicio
              sudo systemctl daemon-reload
              sudo systemctl enable flowise.service
              sudo systemctl start flowise.service

            # Notificar fin de instalación
              echo ""
              echo "      Flowise se ha instalado. Deberías poder acceder a la web aquí:"
              echo "        http://localhost:3000"
              echo "          Usuario: $vUsuarioWebFlowise"
              echo "          Contraseña: $vContraWebFlowise"
              echo ""
              echo "        Si quieres usar otro usuario y contraseña, módifícalos aquí:"
              echo "          /etc/systemd/system/flowise.service"
              echo "        ...y ejecuta:"
              echo "          systemctl stop flowise.service && systemctl daemon-reload && systemctl start flowise.service"
              echo ""
              echo "        Si no funciona el servicio, es posible lanzar Flowise desde la línea de comandos, ejecutando como root:"
              echo "          su - flowise -c '/opt/flowise/bin/flowise start'"
              echo "            o, para tener usuario y contraseña:"
              echo "          su - flowise -c '/opt/flowise/bin/flowise start --FLOWISE_USERNAME=$vUsuarioWebFlowise --FLOWISE_PASSWORD=$vContraWebFlowise'"
              echo ""
              echo "        Es posible asegurar un ChatFlow con una API key. Mas info en:"
              echo "          https://docs.flowiseai.com/configuration/authorization/chatflow-level"
              echo ""

          ;;

         10)

            echo ""
            echo "  Instalando LibreChat..."
            echo ""

            # Instalar Node.js
              echo ""
              echo "    Instalando Node.js..."
              echo ""
              # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install curl
                  echo ""
                fi
              curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Node.js-InstalarYConfigurar.sh | sudo bash

            # Instalar MongoDB
              echo ""
              echo "    Instalando MongoDB..."
              echo ""
              curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-MongoDB-Instalar.sh | sudo bash

            # Clonar repositorio
              mkdir -p $HOME/IA/ 2> /dev/null
              rm -rf $HOME/IA/LibreChat/
              cd $HOME/IA/
              # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install git
                  echo ""
                fi
              git clone https://github.com/danny-avila/LibreChat.git

            # Preparar carpeta final
              sudo mv $HOME/IA/LibreChat/ /opt/
              sudo mv /opt/LibreChat/ /opt/librechat/

            # Compilar
              cd /opt/librechat/
              cp .env.example .env
              # Modificar la URL de la base de datos
                #sed -i -e 's|MONGO_URI=mongodb://127.0.0.1:27017/LibreChat|MONGO_URI=mongodb://127.0.0.1:27017/LibreChat|g' /root/SoftInst/LibreChat/.env
              # Instalar dependencias
                npm ci
              # Construir el frontend
                npm run frontend
              # Especificar el directorio de datos donde MongoDB guardará los archivos
                mkdir -p /opt/librechat/mongodb/
                sudo chown mongodb:mongodb /opt/librechat/mongodb/
                cd /usr/bin
                sudo ./mongod --dbpath=/opt/librechat/mongodb

            # Agregar ollama como endpoint
              cd /opt/librechat/
              cp librechat.example.yaml librechat.yaml
              sed -i '/endpoints:/,$d' librechat.yaml
              echo 'endpoints:'                                                      >> librechat.yaml
              echo '  custom:'                                                       >> librechat.yaml
              echo '    - name: "Ollama"'                                            >> librechat.yaml
              echo '      apiKey: "ollama"'                                          >> librechat.yaml
              echo '      baseURL: "http://127.0.0.1:11434/v1/chat/completions"'     >> librechat.yaml
              echo '      models:'                                                   >> librechat.yaml
              echo '        default: ['                                              >> librechat.yaml
              echo '          "llama3:8b",'                                          >> librechat.yaml
              echo '          "llama3:70b"'                                          >> librechat.yaml
              echo '          ]'                                                     >> librechat.yaml
              echo '        fetch: false # fetching list of models is not supported' >> librechat.yaml
              echo '      titleConvo: true'                                          >> librechat.yaml
              echo '      titleModel: "current_model"'                               >> librechat.yaml
              echo '      summarize: false'                                          >> librechat.yaml
              echo '      summaryModel: "current_model"'                             >> librechat.yaml
              echo '      forcePrompt: false'                                        >> librechat.yaml
              echo '      modelDisplayLabel: "Ollama"'                               >> librechat.yaml
              echo '      addParams:'                                                >> librechat.yaml
              echo '            "stop": ['                                           >> librechat.yaml
              echo '              "<|start_header_id|>",'                            >> librechat.yaml
              echo '              "<|end_header_id|>",'                              >> librechat.yaml
              echo '              "<|eot_id|>",'                                     >> librechat.yaml
              echo '              "<|reserved_special_token"'                        >> librechat.yaml
              echo '            ]'                                                   >> librechat.yaml

            # Notificar fin de la instalación
              echo ""
              echo "      La instalación de LibreChat ha finalizado."
              echo ""
              echo "        Para poner tu OPENAI_API_KEY edita: /opt/librechat/.env"
              echo ""
              echo "        Para iniciar el servidor, ejecuta:"
              echo "          cd /opt/librechat/ && npm run backend"
              echo ""
              echo "        Para actualizar LibreChat, ejecuta:"
              echo "          cd /opt/librechat/ && npm ci && npm run frontend"
              echo ""
              echo "        Una vez iniciado el servidor podrás acceder a él en:"
              echo "          http://localhost:3080"
              echo ""

          ;;

         11)

            echo ""
            echo "  Instalando LiteLLM (Proxy)..."
            echo ""

          ;;

      esac

  done

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi
