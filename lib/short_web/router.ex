defmodule ShortWeb.Router do
  use ShortWeb, :router

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

  scope "/", ShortWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/:hash", LinkController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShortWeb do
  #   pipe_through :api
  # end
end
