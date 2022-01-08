defmodule Short.LinksTest do
  use Short.DataCase

  alias Short.Links
  alias Short.Links.Link

  import Mox

  setup :verify_on_exit!

  setup_all do
    %{config: Application.get_env(:short, Links)}
  end

  describe "create_link/1" do
    test "creates the link and returns a success tuple with a valid URL" do
      assert {
               :ok,
               %Link{id: _, url: "https://example.com", hash: <<_::56>>}
             } = Links.create_link(%{url: "https://example.com"})
    end

    test "does not create the link and returns an error tuple with an invalid format URL" do
      assert {:error, changeset} = Links.create_link(%{url: "ftp://example.com"})
      assert "has invalid format" in errors_on(changeset).url
    end

    test "does not create the link and returns an error tuple with a very short URL" do
      assert {:error, changeset} = Links.create_link(%{url: "http://"})
      assert "should be at least 8 character(s)" in errors_on(changeset).url
    end
  end

  describe "create_link/1 when the hash exists" do
    setup %{config: config} do
      {:ok, _} = Repo.insert(%Link{url: "https://example.com", hash: "example"})

      Application.put_env(
        :short,
        Links,
        put_in(config[:hash_generator], Short.Links.MockHash)
      )

      on_exit(fn -> Application.put_env(:short, Links, config) end)

      :ok
    end

    test "returns an error tuple" do
      Short.Links.MockHash
      |> expect(:generate, fn -> "example" end)

      assert {:error, changeset} = Links.create_link(%{url: "http://example.org/other"})
      assert "has already been taken" in errors_on(changeset).hash
    end
  end
end
