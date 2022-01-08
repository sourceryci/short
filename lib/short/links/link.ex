defmodule Short.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  @url_regex ~r/https?:\/\/.+/

  schema "links" do
    field :url, :string
    field :hash, :string

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :hash])
    |> validate_required([:url, :hash])
    |> validate_length(:url, min: 8, max: 32_779)
    |> validate_format(:url, @url_regex)
    |> validate_length(:hash, min: 7)
    |> check_constraint(:url, name: :url_check)
    |> unique_constraint(:hash)
  end
end
