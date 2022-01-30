defmodule ShortWeb.LiveDashboard.LinkViewsPage do
  @moduledoc false
  use Phoenix.LiveDashboard.PageBuilder

  import Ecto.Query, warn: false

  @impl true
  def menu_link(_, _) do
    {:ok, "Link Views"}
  end

  @impl true
  def render_page(_assigns) do
    table(
      columns: columns(),
      id: :link_views,
      row_attrs: &row_attrs/1,
      row_fetcher: &fetch_links/2,
      rows_name: "views",
      title: "Link Views"
    )
  end

  # %{limit: 50, search: "zorb", sort_by: :id, sort_dir: :desc}
  defp fetch_links(%{limit: limit, sort_by: sort_by, sort_dir: sort_dir} = params, _node) do
    links =
      from(l in Short.Links.Link,
        where: ^filter_where(params[:search]),
        order_by: ^filter_order_by(%{sort_by: sort_by, sort_dir: sort_dir}),
        limit: ^limit
      )
      |> Short.Repo.all()
      |> Enum.map(&Map.from_struct/1)

    {links, length(links)}
  end

  defp columns do
    [
      %{field: :id, header: "ID", sortable: :asc},
      %{field: :url, header: "URL"},
      %{field: :hash, header: "Hash"},
      %{field: :views, header: "Views", sortable: :asc}
    ]
  end

  defp row_attrs(_) do
    []
  end

  defp filter_where(nil), do: true

  defp filter_where(search) do
    expression = "%#{search}%"

    dynamic([l], ilike(l.url, ^expression) or ilike(l.hash, ^expression))
  end

  defp filter_order_by(%{sort_by: nil}) do
    [desc: :id]
  end

  defp filter_order_by(%{sort_by: sort_by, sort_dir: sort_dir}) do
    [{sort_dir, sort_by}]
  end
end
