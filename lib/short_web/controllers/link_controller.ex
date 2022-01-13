defmodule ShortWeb.LinkController do
  use ShortWeb, :controller

  alias Short.Links
  alias Short.Links.Link

  action_fallback ShortWeb.FallbackController

  plug :rate_limit when action in [:create]

  def create(conn, %{"link" => %{"url" => url}}) do
    with {:ok, %Link{} = link} <- Links.create_link(%{url: url}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.link_path(conn, :show, link))
      |> render("show.json", link: link)
    end
  end

  def create(conn, _) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Payload not valid"})
  end

  def show(conn, %{"hash" => hash}) do
    case Links.url_for(hash) do
      url when is_bitstring(url) ->
        redirect(conn, external: url)

      _ ->
        conn
        |> put_flash(:error, "Unable to find URL to redirect to")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  defp rate_limit(conn, _) do
    RateLimiter.rate_limit(conn, Application.get_env(:short, RateLimiter)[:defaults])
  end
end
