#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para convertir texto a audio utilizando la API de OpenAI y hacerlo sonar por los altavoces
#
# Ejecución remota con parámetros (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/ia-scripts/refs/heads/main/Audio/OpenAI-TTS-ToSpeaker.py | python3 - --apikey "xxx" --texto "Hola mundo"
# ----------

# Requisitos:
#   sudo apt-get -y install python3-pip python3-numpy
#   python3 -m pip install --upgrade openai --break-system-packages

# Uso:
#   Parametros minimos:
#     OpenAI-ReproducirTexto.py --apikey "xxx" --texto "Este es un test en español"
#   Parametros completos:
#     OpenAI-ReproducirTexto.py --apikey "xxx" --texto "Este es un test en español" --modelo "gpt-4o-mini-tts" --voz "coral" --instrucciones "Habla con tono alegre"

import asyncio
import argparse
from openai import AsyncOpenAI
from openai.helpers import LocalAudioPlayer

async def main():
  parser = argparse.ArgumentParser(description="Reproducir texto con OpenAI TTS")
  parser.add_argument("--apikey",        required=True,             help="API Key de OpenAI")
  parser.add_argument("--texto",         required=True,             help="Texto a convertir en audio")
  parser.add_argument("--modelo",        default="gpt-4o-mini-tts", help="Modelo TTS a usar")
  parser.add_argument("--voz",           default="coral",           help="Voz a usar")
  parser.add_argument("--instrucciones", default="",                help="Instrucciones adicionales para la voz")
  args = parser.parse_args()

  # Cliente con la API Key proporcionada
  vCliente = AsyncOpenAI(api_key=args.apikey)

  # Crear audio y reproducirlo directamente
  async with vCliente.audio.speech.with_streaming_response.create(
    model=args.modelo,
    voice=args.voz,
    input=args.texto,
    instructions=args.instrucciones,
    response_format="pcm",
  ) as response:
    await LocalAudioPlayer().play(response)

if __name__ == "__main__":
  asyncio.run(main())
