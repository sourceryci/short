defmodule ShortWeb.PageViewTest do
  use ShortWeb.ConnCase, async: true

  import Phoenix.View

  test "renders index.html" do
    assert render_to_string(ShortWeb.PageView, "index.html", []) =~
             "<p>The alchemist's URL shortener of choice</p>"
  end
end
