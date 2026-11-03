FROM hexpm/elixir:1.18.3-erlang-27.3.3-alpine-3.21.3

ENV LANG=C.UTF-8
ENV MIX_ENV=prod

RUN apk add --no-cache --update \
    build-base \
    git \
    curl \
    openssl \
    ncurses-libs \
    nodejs \
    npm \
    postgresql-dev

WORKDIR /app/glific

RUN mix local.hex --force && \
    mix local.rebar --force

# Copia mix.exs e mix.lock primeiro (para cache)
COPY mix.exs mix.lock ./

# Como o Oban Pro está desabilitado, forçamos a limpeza de deps não usadas
RUN mix deps.get --only prod
RUN mix deps.compile

# Copia o restante do código
COPY . .

# Garante a pasta de certificados
RUN mkdir -p priv/cert

# Compila a aplicação
RUN mix compile

# Porta padrão (o Render sobrescreve com $PORT)
EXPOSE 4000

# Usa o entrypoint
ENTRYPOINT ["/bin/sh", "/app/glific/config/entrypoint.sh"]
