# This is a common trick demonstrated in https://pragprog.com/titles/wmecto/programming-ecto/
# to avoid repetitive typing (see section "Optimizing IEx for Ecto").
import_if_available(Ecto.Query)
import_if_available(Ecto.Changeset)

alias Short.Repo
alias Short.Links
alias Short.Links.{Link, Hash}
alias ShortWeb.Router.Helpers, as: Routes

defmodule H do
  # Example:
  #
  # w = Repo.get(Webhook, 1)
  # H.update(w, %{payload: "updated payload"})
  def update(schema, changes) do
    schema
    |> Ecto.Changeset.change(changes)
    |> Repo.update()
  end
end
