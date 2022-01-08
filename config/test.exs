import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :short, Short.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "postgres",
  database: "short_test#{System.get_env("MIX_TEST_PARTITION")}",
  port: "5432",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :short, ShortWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "bFBXgRK6JKZVJy+BogMjs+gMqU2QUN3RJ3KqYzpyCsQj3j7K3gh+O43Y9Nq0ioBd",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
