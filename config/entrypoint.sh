#!/bin/sh
set -e

ROOT="/app/glific/priv/cert"
GLIFIC_FIRST_STARTUP="$ROOT/GLIFIC_FIRST_STARTUP"

# Garante que a pasta de certificados existe
mkdir -p "$ROOT"

if [ ! -e "$GLIFIC_FIRST_STARTUP" ]; then
    echo "First startup detected. Initializing database..."
    touch "$GLIFIC_FIRST_STARTUP"
    # Apenas executa as migrações iniciais de forma segura, sem resetar o banco
    mix ecto.create || true
    mix ecto.migrate
fi

echo "Starting Phoenix server on port ${PORT:-4000}..."
exec PORT=${PORT:-4000} mix phx.server
