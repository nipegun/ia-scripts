#!/bin/bash
watch -n 2 "ps aux | grep 'ollama' | grep -v 'grep' | awk '{sum += \$6} END {print sum / 1024 \" MB\"}'"
