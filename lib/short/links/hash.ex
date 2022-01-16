defmodule Short.Links.Hash do
  @moduledoc """
  Generates a random URL-friendly hash to be used as a short identifier for a URL
  """

  @callback generate() :: String.t()
  def generate do
    :crypto.strong_rand_bytes(size())
    |> Base.url_encode64(padding: false)
  end

  defp size, do: Application.get_env(:short, __MODULE__)[:size]
end
