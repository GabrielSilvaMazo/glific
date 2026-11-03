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

COPY mix.exs ./
COPY mix.lock* ./

RUN mix deps.get --only prod
RUN mix deps.compile

COPY . .

RUN mkdir -p priv/cert

RUN mix compile

EXPOSE 4000

ENTRYPOINT ["/bin/sh", "/app/glific/config/entrypoint.sh"]
