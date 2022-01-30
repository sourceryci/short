defmodule Short.Repo.Migrations.AddViewsToLinks do
  use Ecto.Migration

  def change do
    alter table("links") do
      add :views, :integer, default: 0
    end

    create constraint("links", "views_must_be_positive", check: "views >= 0")
  end
end
