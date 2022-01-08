defmodule ShortWeb.PageControllerTest do
  use ShortWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "The Alchemist's URL shortener of choice"
  end
end
