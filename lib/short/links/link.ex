defmodule Short.Links.Link do
  @moduledoc "The schema module for a Link"

  use Ecto.Schema
  import Ecto.Changeset

  @url_regex ~r/https?:\/\/.+/

  schema "links" do
    field :url, :string
    field :hash, :string
    field :views, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :hash, :views])
    |> validate_required([:url, :hash])
    |> validate_length(:url, min: 8, max: 32_779)
    |> validate_format(:url, @url_regex)
    |> validate_length(:hash, min: 7)
    |> validate_number(:views, greater_than_or_equal_to: 0)
    |> check_constraint(:url, name: :url_check)
    |> check_constraint(:views, name: :views_check)
    |> unique_constraint(:hash)
  end
end
