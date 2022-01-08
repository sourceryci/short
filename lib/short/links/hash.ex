defmodule Short.Links.Hash do
  @callback generate() :: String.t()
  def generate do
    :crypto.strong_rand_bytes(size())
    |> Base.url_encode64(padding: false)
  end

  defp size, do: Application.get_env(:short, __MODULE__)[:size]
end
