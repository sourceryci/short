defmodule ShortWeb.LinkView do
  use ShortWeb, :view
  alias ShortWeb.LinkView

  def render("show.json", %{link: link}) do
    %{data: render_one(link, LinkView, "link.json")}
  end

  def render("link.json", %{link: %{url: url, hash: hash}}) do
    %{
      url: url,
      hash: hash,
      short_url: Routes.link_url(ShortWeb.Endpoint, :show, hash)
    }
  end
end
