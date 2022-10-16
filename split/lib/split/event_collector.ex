defmodule Split.EventCollector do
  use GenServer

  require Logger
  alias Split.City

  # --- Client Api ---
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def add_visitor(%City{} = city) do
    server = {:via, PartitionSupervisor, {EventCollectorPartitionSupervisor, city}}
    GenServer.cast(server, {:incr_visitor_count, city})
  end

  def flush_visitor_count(_city) do
    partition = 1
    server = {:via, PartitionSupervisor, {EventCollectorPartitionSupervisor, partition}}
    GenServer.call(server, :flush_visitors)
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
