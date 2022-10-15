defmodule Split.EventCollector do
  use GenServer

  require Logger
  alias Split.City

  # --- Client Api ---
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def add_visitor(%City{} = city) do
    GenServer.cast(__MODULE__, {:incr_visitor_count, city})
  end

  def flush_visitor_count do
    GenServer.call(__MODULE__, :flush_visitors)
  end

  # --- Server Callbacks ---

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:incr_visitor_count, %City{} = city}, visitors) do
    # business logic
    updated_visitors = Map.update(visitors, city.name, 1, &(&1 + 1))
    {:noreply, updated_visitors}
  end

  @impl true
  def handle_call(:flush_visitors, _from, visitors) do
    {:reply, visitors, %{}}
  end
end
