#!/bin/bash

vUsuario='DavidAU'
vRepo='OpenAi-GPT-oss-20b-abliterated-uncensored-NEO-Imatrix-gguf'

curl -s https://huggingface.co/api/models/"$vUsuario"/"$vRepo" | grep -i gguf | jq

