#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para convertir texto a audio utilizando la API de OpenAI
#
# Ejecución remota con parámetros (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/Audio/OpenAI-TTS-ToFile.py | python3 - [APIKey] [Texto] [Modelo] [Voz] [Instrucciones] [ArchivoDeSalida]
# ----------

# Requisitos:
#   sudo apt-get -y install python3-pip
#   python3 -m pip install --upgrade openai --break-system-packages

# Uso:
#   Parametros minimos:
#     OpenAI-CrearMP3-DeTexto.py --apikey "xxx" --texto "Este es un test en español"
#   Parametros completos:
#     OpenAI-CrearMP3-DeTexto.py --apikey "xxx" --texto "Este es un test en español" --modelo "gpt-4o-mini-tts" --voz "coral" --instrucciones "Habla con tono alegre" --salida "TextoAVoz.mp3"

import argparse
from pathlib import Path
from openai import OpenAI

def main():
  parser = argparse.ArgumentParser(description="Generar audio con OpenAI TTS")
  parser.add_argument("--apikey",        required=True,             help="API Key de OpenAI")
  parser.add_argument("--texto",         required=True,             help="Texto a convertir en audio")
  parser.add_argument("--modelo",        default="gpt-4o-mini-tts", help="Modelo TTS a usar")
  parser.add_argument("--voz",           default="coral",           help="Voz a usar")
  parser.add_argument("--instrucciones", default="",                help="Instrucciones adicionales para la voz")
  parser.add_argument("--salida",        default="AudioIA.mp3",     help="Archivo de salida")

  args = parser.parse_args()

  vCliente = OpenAI(api_key=args.apikey)
  vArchivoDeAudio = Path(args.salida)

  with vCliente.audio.speech.with_streaming_response.create(
    model=args.modelo,
    voice=args.voz,
    input=args.texto,
    instructions=args.instrucciones,
  ) as response:
    response.stream_to_file(vArchivoDeAudio)

  print(f"Audio generado en: {vArchivoDeAudio}")

if __name__ == "__main__":
  main()

