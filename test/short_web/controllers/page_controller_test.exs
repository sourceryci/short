defmodule ShortWeb.PageControllerTest do
  use ShortWeb.ConnCase

  import Plug.BasicAuth

  alias ShortWeb.PageController

  setup do
    %{config: Application.get_env(:short, PageController)}
  end

  test "GET / with valid basic auth credentials", %{
    conn: conn,
    config: %{basic_auth: %{username: username, password: password}}
  } do
    conn =
      conn
      |> put_req_header("authorization", encode_basic_auth(username, password))
      |> basic_auth(username: username, password: password)
      |> get("/")

    assert html_response(conn, 200) =~ "The Alchemist's URL shortener of choice"
  end

  test "GET / with invalid basic auth credentials", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", encode_basic_auth("some_user", "invalid_pass"))
      |> basic_auth(username: "some_user", password: "invalid_pass")
      |> get("/")

    assert %{status: 401, resp_body: "Unauthorized"} = conn
  end
end
