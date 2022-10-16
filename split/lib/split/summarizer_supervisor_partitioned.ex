defmodule Split.SummarizerSupervisorPartitoned do
  use Supervisor

  alias Split.EventCollector
  alias Split.EventFlusher

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    partitions = 3

    children = [
      {
        PartitionSupervisor,
        child_spec: EventCollector,
        name: EventCollectorPartitionSupervisor,
        partitions: partitions
      },
      {
        PartitionSupervisor,
        child_spec: EventFlusher,
        name: EventFlusherPartitonSupervisor,
        partitions: partitions,
        with_arguments: fn [opts], partition -> [Keyword.put(opts, :partition, partition)] end
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
