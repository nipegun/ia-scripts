            8)

              echo ""
              echo "  Instalando el modelo tiny"
              echo ""
              # Posicionarse en la carpeta:
                cd ~/repos/cpp/whisper.cpp/
              # Descargar
                ./models/download-ggml-model.sh tiny

              # Notificar fin de la instalación del modelo
                echo ""
                echo -e "${cColorVerde}    Modelo tiny, instalado. Para aplicar el modelo tiny a un archivo de audio/video:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      /home/$USER/repos/cpp/whisper.cpp/build/bin/whisper-cli -m /home/$USER/repos/cpp/whisper.cpp/models/ggml-tiny.bin -f /Ruta/Al/Archivo/De/AudioVideo.wav${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        o${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      /home/USER/repos/cpp/whisper.cpp/build/bin/whisper-cli -m /home/$USER/repos/cpp/whisper.cpp/models/ggml-tiny.bin -f /Ruta/Al/Archivo/De/AudioVideo.mp4${cFinColor}"
                echo ""

            ;;
            9)

              echo ""
              echo "  Instalando el modelo base"
              echo ""
              # Posicionarse en la carpeta:
                cd ~/repos/cpp/whisper.cpp/
              # Descargar
                ./models/download-ggml-model.sh base

              # Notificar fin de la instalación del modelo
                echo ""
                echo -e "${cColorVerde}    Modelo base, instalado. Para aplicar el modelo base a un archivo de audio/video:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      /home/$USER/repos/cpp/whisper.cpp/build/bin/whisper-cli -m /home/$USER/repos/cpp/whisper.cpp/models/ggml-base.bin -f /Ruta/Al/Archivo/De/AudioVideo.wav${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        o${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      /home/USER/repos/cpp/whisper.cpp/build/bin/whisper-cli -m /home/$USER/repos/cpp/whisper.cpp/models/ggml-base.bin -f /Ruta/Al/Archivo/De/AudioVideo.mp4${cFinColor}"
                echo ""

            ;;
