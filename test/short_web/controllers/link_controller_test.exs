defmodule ShortWeb.LinkControllerTest do
  use ShortWeb.ConnCase

  alias Short.Links

  @create_attrs %{
    url: "https://verylongurl.com"
  }

  @invalid_attrs %{
    url: "ftp://nope.gov"
  }

  describe "create link" do
    setup %{conn: conn} do
      {:ok, conn: put_req_header(conn, "accept", "application/json")}
    end

    test "renders link when data is valid", %{conn: conn} do
      conn = post(conn, Routes.link_path(conn, :create), link: @create_attrs)

      assert %{
               "url" => "https://verylongurl.com",
               "hash" => hash,
               "short_url" => short_url
             } = json_response(conn, 201)["data"]

      assert short_url == Routes.link_url(conn, :show, hash)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.link_path(conn, :create), link: @invalid_attrs)

      assert json_response(conn, 422)["errors"] == %{"url" => ["has invalid format"]}
    end

    test "renders errors when data is blank", %{conn: conn} do
      conn = post(conn, Routes.link_path(conn, :create), link: %{})

      assert json_response(conn, 400)["error"] == "Payload not valid"
    end
  end

  describe "navigate to a link hash when the links exists" do
    setup do
      {:ok, link} = Links.create_link(%{url: "https://verylongurl.com"})

      %{link: link}
    end

    test "it redirects to the long URL", %{conn: conn, link: link} do
      conn = get(conn, Routes.link_path(conn, :show, link.hash))

      assert redirected_to(conn) == "https://verylongurl.com"
    end
  end

  describe "navigate to a link hash when the links does not exist" do
    test "it redirects to the root path with a flash message", %{conn: conn} do
      conn = get(conn, Routes.link_path(conn, :show, "RanDomHash"))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :error) == "Unable to find URL to redirect to"
    end
  end
end
