#!/usr/bin/env bash
# Push-to-talk voice-to-text: Super+Y to start recording, Super+Y again to stop and transcribe

PIDFILE="/tmp/voice-to-text.pid"
LOCKFILE="/tmp/voice-to-text.lock"
AUDIOFILE="/tmp/voice-to-text-recording.wav"
MODEL="${WHISPER_MODEL:-$HOME/.local/share/whisper-models/ggml-large-v3.bin}"
DEVICE="${WHISPER_DEVICE:-0}"

exec 200>"$LOCKFILE"
flock -n 200 || exit 0

# If recording is active, stop it and transcribe
if [[ -f "$PIDFILE" ]]; then
    pid=$(cat "$PIDFILE")
    if kill -0 "$pid" 2>/dev/null; then
        # Stop recording
        kill "$pid" 2>/dev/null
        wait "$pid" 2>/dev/null
        rm -f "$PIDFILE"

        notify-send -t 1000 "🎤 Voice to Text" "Transcribing..."

        # Transcribe the recording with whisper (not streaming)
        if [[ -f "$AUDIOFILE" ]]; then
            # Run whisper on the recorded audio file
            text=$(whisper -m "$MODEL" -f "$AUDIOFILE" -t 8 -nt 2>/dev/null | grep -v '^\[' | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

            if [[ -n "$text" ]]; then
                wtype -- "$text "
                notify-send -t 2000 "🎤 Voice to Text" "Done: ${text:0:50}..."
            else
                notify-send -t 2000 "🎤 Voice to Text" "No speech detected"
            fi
            rm -f "$AUDIOFILE"
        fi
        exit 0
    fi
    rm -f "$PIDFILE"
fi

# Start recording
notify-send -t 2000 "🎤 Voice to Text" "Recording... (Super+Y to stop)"

# Record audio using pw-record (PipeWire) - runs in background
pw-record --target="$DEVICE" "$AUDIOFILE" &
echo $! > "$PIDFILE"
