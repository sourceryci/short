defmodule ShortWeb.PageViewTest do
  use ShortWeb.ConnCase, async: true

  import Phoenix.View

  test "renders index.html" do
    assert render_to_string(ShortWeb.PageView, "index.html", []) =~
             "he Alchemist's URL shortener of choice"
  end
end
