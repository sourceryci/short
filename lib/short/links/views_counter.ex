defmodule Short.Links.ViewsCounter do
  @moduledoc """
  Keeps a temporary counter per link.
  Increases the counter each time a link is visited.
  Flushes the counters periodically.
  """

  # seconds
  @flush_interval 5

  use GenServer

  def add(id), do: add(__MODULE__, id)
  def add(pid, id), do: GenServer.cast(pid, {:add, id})

  def start_link(%{name: name} = args), do: GenServer.start_link(__MODULE__, args, name: name)
  def start_link(args), do: GenServer.start_link(__MODULE__, args)

  # Callbacks

  @impl true
  def init(%{flush_callback: flush_callback} = opts) do
    schedule_flush()

    {:ok,
     %{
       flush_callback: flush_callback,
       interval: opts[:interval] || @flush_interval,
       counters: %{}
     }}
  end

  @impl true
  def handle_cast({:add, id}, %{counters: counters} = state) do
    {_, updated_counters} =
      Map.get_and_update(counters, id, fn
        nil -> {nil, 1}
        val -> {val, val + 1}
      end)

    {:noreply, %{state | counters: updated_counters}}
  end

  @impl true
  def handle_info(:flush, %{flush_callback: flush_callback, counters: counters} = state) do
    for {id, counter} <- counters, do: flush_callback.(id, counter)

    schedule_flush()

    {:noreply, %{state | counters: %{}}}
  end

  defp schedule_flush do
    Process.send_after(self(), :flush, :timer.seconds(@flush_interval))
  end
end
