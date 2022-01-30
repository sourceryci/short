defmodule ShortWeb.Router do
  use ShortWeb, :router

  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ShortWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    post "/links", ShortWeb.LinkController, :create
  end

  pipeline :admins_only do
    plug :auth
  end

  scope "/", ShortWeb do
    pipe_through :browser

    get "/:hash", LinkController, :show
  end

  scope "/", ShortWeb do
    pipe_through :browser
    pipe_through :admins_only

    get "/", PageController, :index
  end

  scope "/admin" do
    pipe_through :browser
    pipe_through :admins_only

    live_dashboard "/dashboard", ecto_repos: [Short.Repo]
  end

  defp auth(conn, _opts) do
    config = Application.get_env(:short, :basic_auth)

    Plug.BasicAuth.basic_auth(conn, username: config[:username], password: config[:password])
  end
end
