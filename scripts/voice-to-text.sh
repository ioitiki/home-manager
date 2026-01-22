#!/usr/bin/env bash
# Voice-to-text using whisper-stream and wtype
# Press Ctrl+C to stop

MODEL="${WHISPER_MODEL:-$HOME/.local/share/whisper-models/ggml-large-v3.bin}"
DEVICE="${WHISPER_DEVICE:-2}"

whisper-stream \
    -m "$MODEL" \
    -c "$DEVICE" \
    -t 8 \
    --step 200 \
    --length 8000 \
    --vad-thold 0.9 \
    -nf \
    2>/dev/null | while IFS= read -r line; do
    # Skip empty lines, status messages, and hallucinations
    if [[ -z "$line" ]] || \
       [[ "$line" =~ ^\[.*\]$ ]] || \
       [[ "$line" =~ ^whisper_ ]] || \
       [[ "$line" =~ ^load_ ]] || \
       [[ "$line" =~ ^init: ]] || \
       [[ "$line" =~ ^main: ]] || \
       [[ "$line" == " Thank you." ]] || \
       [[ "$line" == " [BLANK_AUDIO]" ]]; then
        continue
    fi

    # Remove leading space and type the text
    text="${line# }"
    if [[ -n "$text" ]]; then
        wtype "$text "
    fi
done
