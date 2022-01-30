# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :short,
  ecto_repos: [Short.Repo]

# Configures the endpoint
config :short, ShortWeb.Endpoint,
  url: [host: "localhost", port: 8080],
  render_errors: [view: ShortWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Short.PubSub,
  live_view: [signing_salt: "yxLFXxgM"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args: ~w(js/app.js
       --bundle
       --target=es2017
       --outdir=../priv/static/assets
       --external:/fonts/*
       --external:/images/*
       --loader:.js=jsx),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tailwind,
  version: "3.0.12",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :short, ShortWeb.RateLimiter, defaults: %{interval_seconds: 1, max_requests: 10}

config :short, :basic_auth, %{
  username: "eugene",
  password: "that axe"
}

config :short, Short.Links.Hash,
  # The number of random bytes to use to generate the hash
  size: 5

# Dependency Injection
config :short, Short.Links, hash_generator: Short.Links.Hash

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
