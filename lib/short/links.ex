defmodule Short.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias Short.Repo

  alias Short.Links.Link

  @doc """
  Gets a single link for the given hash
  """
  def url_for(hash), do: Repo.one(from l in Link, where: l.hash == ^hash, select: l.url)

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{url: "https://example.com", hash: "shorthash"})
      {:ok, %Link{}}

      iex> create_link(%{url: "javascript:alert('hello')"})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(%{url: url}) do
    %Link{}
    |> Link.changeset(%{url: url, hash: hash_generator().generate})
    |> Repo.insert()
  end

  defp hash_generator do
    Application.get_env(:short, __MODULE__)[:hash_generator]
  end
end
