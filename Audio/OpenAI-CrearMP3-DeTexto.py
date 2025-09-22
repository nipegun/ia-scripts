#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Requisitos:
#   sudo apt-get -y install python3-pip
#   python3 -m pip install --upgrade openai --break-system-packages

from pathlib import Path
from openai import OpenAI

vAPIKey = "xxx"
vTexto = 'This is a test!'
vModelo = 'gpt-4o-mini-tts'
vVoz = 'coral'
vInstrucciones = 'Speak in a cheerful and positive tone.'

vCliente = OpenAI(api_key=vAPIKey)
vArchivoDeAudio = Path(__file__).parent / "Audio.mp3"

with vCliente.audio.speech.with_streaming_response.create(
    model=vModelo,
    voice=vVoz,
    input=vTexto,
    instructions=vInstrucciones,
) as response:
    response.stream_to_file(vArchivoDeAudio)
