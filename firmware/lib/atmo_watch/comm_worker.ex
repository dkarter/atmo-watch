defmodule AtmoWatch.CommWorker do
  use GenServer

  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl GenServer
  def init(:ok) do
    # timer =
    #   :timer.seconds(5)
    #   |> :timer.send_interval(:ping)

    {:ok, %{}}
  end

  @impl GenServer
  def handle_info(:ping, state) do
    Logger.info("Got a ping..")

    [url: "https://httpbin.org/response-headers?freeform=hello"]
    |> Req.new()
    |> Req.request()
    |> inspect()
    |> Logger.info()

    {:noreply, state}
  end
end
