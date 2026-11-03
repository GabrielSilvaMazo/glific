FROM hexpm/elixir:1.18.3-erlang-27.3.3-alpine-3.21.3

ARG NODE_VERSION=20
ARG POSTGRES_VERSION=16
ARG FP=DOES_NOT_EXIST
ARG AUTH_KEY=DOES_NOT_EXIST

ENV LANG=C.UTF-8
ENV MIX_ENV=prod

# Instalação de dependências do sistema
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

# Hex + Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# (Opcional - só descomente se tiver licença do Oban Pro)
# RUN mix hex.repo add oban https://getoban.pro/repo --fetch-public-key $FP --auth-key $AUTH_KEY || true

# Copia apenas o necessário para cache de dependências
COPY mix.exs ./

RUN mix deps.get --only prod
RUN mix deps.compile

# Copia o restante do código
COPY . .

# Compila a aplicação
RUN mix compile

ENTRYPOINT ["/bin/sh", "/app/glific/config/entrypoint.sh"]
