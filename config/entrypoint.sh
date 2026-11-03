#!/bin/sh
set -e

ROOT="/app/glific/priv/cert"
GLIFIC_FIRST_STARTUP="$ROOT/GLIFIC_FIRST_STARTUP"

# Garante que a pasta existe
mkdir -p "$ROOT"

if [ ! -e "$GLIFIC_FIRST_STARTUP" ]; then
    echo "First startup detected. Running mix setup..."
    touch "$GLIFIC_FIRST_STARTUP"
    mix setup
fi

echo "Starting Phoenix server..."
exec mix phx.server
