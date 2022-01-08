defmodule Short.Links.HashTest do
  use ExUnit.Case, async: true

  alias Short.Links.Hash

  describe "generate/0" do
    setup do
      %{size: Application.get_env(:short, Hash)[:size]}
    end

    test "returns a different hash each time" do
      hashes = for(_ <- 1..10, do: Hash.generate()) |> Enum.uniq()

      assert length(hashes) == 10
    end

    test "generates URL-safe hashes" do
      assert {:ok, _} = Base.url_decode64(Hash.generate(), padding: false)
    end

    test "generates strings of the configured size", %{size: size} do
      # Each Base 64 digit represents exactly 6 bits
      assert String.length(Hash.generate()) == ceil(size * 8 / 6)
    end
  end
end
