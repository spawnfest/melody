defmodule Split do
  @moduledoc """
  Documentation for `Split`.
  """

  alias Split.SummarizerSupervisor
  alias Split.EventCollector
  alias Split.City

  def run do
    if Process.whereis(SummarizerSupervisor) do
      Supervisor.stop(SummarizerSupervisor)
    end

    SummarizerSupervisor.start_link([])
    |> IO.inspect()

    test_visitors = [
      %City{id: "1", name: :mumbai},
      %City{id: "2", name: :bengaluru},
      %City{id: "3", name: :pune},
      %City{id: "4", name: :mumbai},
      %City{id: "5", name: :bengaluru}
    ]

    1..500_000
    |> Task.async_stream(
      fn _ ->
        visitor = Enum.random(test_visitors)
        EventCollector.add_visitor(visitor)
      end,
      max_concurrency: 2_000
    )
    |> Stream.run()
  end
end
