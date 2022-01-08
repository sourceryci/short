defmodule Short.Repo.Migrations.CreateLinksTable do
  use Ecto.Migration

  def change do
    execute ~S"""
            CREATE DOMAIN url AS text
            CHECK (VALUE ~ 'https?:\/\/.+')
            """,
            "DROP DOMAIN url"

    create table("links") do
      add :url, :url, null: false
      add :hash, :text, null: false

      timestamps
    end

    create index("links", [:hash], unique: true, include: ["url"])
  end
end
