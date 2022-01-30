defmodule Short.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Short.Repo,
      {Short.Links.ViewsCounter, %{name: Short.Links.ViewsCounter, flush_callback: &Short.Links.update_views/2}},
      # Start the Telemetry supervisor
      ShortWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Short.PubSub},
      # Start the Endpoint (http/https)
      ShortWeb.Endpoint
      # Start a worker by calling: Short.Worker.start_link(arg)
      # {Short.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Short.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShortWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
