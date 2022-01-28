defmodule ShortWeb.PageController do
  use ShortWeb, :controller

  plug :auth when action in [:index]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  defp auth(conn, _opts) do
    Plug.BasicAuth.basic_auth(conn,
      username: config()[:basic_auth][:username],
      password: config()[:basic_auth][:password]
    )
  end

  defp config, do: Application.get_env(:short, __MODULE__)
end
