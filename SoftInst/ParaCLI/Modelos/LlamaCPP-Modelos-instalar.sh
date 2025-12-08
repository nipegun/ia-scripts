





curl -L https://huggingface.co/ggml-org/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-mxfp4.gguf -O

curl -L https://huggingface.co/ggml-org/Qwen3-32B-GGUF/resolve/main/Qwen3-32B-Q4_K_M.gguf -O
curl -L https://huggingface.co/ggml-org/Qwen3-32B-GGUF/resolve/main/Qwen3-32B-Q8_0.gguf -O

curl -L https://huggingface.co/ggml-org/Qwen3-14B-GGUF/resolve/main/Qwen3-14B-Q4_K_M.gguf -O
curl -L https://huggingface.co/ggml-org/Qwen3-14B-GGUF/resolve/main/Qwen3-14B-Q8_0.gguf -O
curl -L https://huggingface.co/ggml-org/Qwen3-14B-GGUF/resolve/main/Qwen3-14B-f16.gguf -O


# Gemma 3 12b

mkdir -p $HOME/IA/Modelos/GGUF/ 2> /dev/null
cd $HOME/IA/Modelos/GGUF/
curl -L https://huggingface.co/ggml-org/gemma-3-12b-it-GGUF/resolve/main/gemma-3-12b-it-Q4_K_M.gguf -O

mkdir -p $HOME/IA/Modelos/GGUF/ 2> /dev/null
cd $HOME/IA/Modelos/GGUF/
curl -L https://huggingface.co/ggml-org/gemma-3-12b-it-GGUF/resolve/main/gemma-3-12b-it-Q8_0.gguf -O

mkdir -p $HOME/IA/Modelos/GGUF/ 2> /dev/null
cd $HOME/IA/Modelos/GGUF/
curl -L https://huggingface.co/ggml-org/gemma-3-12b-it-GGUF/resolve/main/gemma-3-12b-it-f16.gguf -O
