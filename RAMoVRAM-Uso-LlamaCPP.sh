#!/bin/bash
watch -n 2 "ps aux | grep 'llama' | grep -v 'grep' | awk '{sum += \$6} END {print sum / 1024 \" MB\"}'"
