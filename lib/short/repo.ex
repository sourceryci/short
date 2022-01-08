defmodule Short.Repo do
  use Ecto.Repo,
    otp_app: :short,
    adapter: Ecto.Adapters.Postgres
end
