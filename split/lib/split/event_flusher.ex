defmodule Split.EventFlusher do
  use GenServer

  alias Split.EventCollector

  require Logger
  # --- Client Api ---
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  # --- Server Api ---
  @impl true
  def init(opts) do
    # 5 seconds for now. Usually we want hourly average
    state = %{
      flush_interval: Keyword.get(opts, :flush_interval, 5_000),
      partition: Keyword.fetch!(opts, :partition)
    }

    {:ok, state, {:continue, :schedule_next_run}}
  end

  @impl true
  def handle_continue(:schedule_next_run, state) do
    Process.send_after(self(), :perform_cron_work, state.partition)
    {:noreply, state}
  end

  @impl true
  def handle_info(:perform_cron_work, state) do
    write_data_to_db = EventCollector.flush_visitor_count(state.partition)

    unless Map.keys(write_data_to_db) == [] do
      Logger.info(write_data_to_db)
    end

    {:noreply, state, {:continue, :schedule_next_run}}
  end
end
