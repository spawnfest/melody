defmodule Split.EventFlusher do
  use GenServer

  alias Split.EventCollector

  require Logger
  # --- Client Api ---
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # --- Server Api ---
  @impl true
  def init(opts) do
    # 5 seconds for now. Usually we want hourly average
    flush_interval = Keyword.get(opts, :flush_interval, 5_000)
    {:ok, flush_interval, {:contniue, :schedule_next_run}}
  end

  @impl true
  def handle_continue(:schedule_next_run, flush_interval) do
    Process.send_after(self(), :perform_cron_work, flush_interval)
    {:noreply, flush_interval}
  end

  @impl true
  def handle_info(:perform_cron_work, flush_interval) do
    write_data_to_db = EventCollector.flush_visitor_count()

    unless map_size(write_data_to_db) == 0 do
      Logger.info(write_data_to_db)
    end

    {:noreply, flush_interval, {:continue, :schedule_next_run}}
  end
end
