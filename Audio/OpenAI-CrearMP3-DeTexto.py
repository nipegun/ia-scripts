#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Requisitos:
#   sudo apt-get -y install python3-pip
#   python3 -m pip install --upgrade openai --break-system-packages

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

