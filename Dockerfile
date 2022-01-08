# Dockerfile for development and test environments

FROM bitwalker/alpine-elixir-phoenix:1.13.1

RUN mkdir /app
WORKDIR /app

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Same with npm deps
ADD assets/package.json assets/
RUN cd assets && \
    npm install

ADD . .

RUN mix compile

CMD ["mix", "phx.server"]
