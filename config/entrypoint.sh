#!/bin/sh
set -e

ROOT="/app/glific/priv/cert"
mkdir -p "$ROOT"

echo "Running database migrations..."
mix ecto.migrate || true

echo "Starting Phoenix server on port ${PORT:-4000}..."
exec mix phx.server
