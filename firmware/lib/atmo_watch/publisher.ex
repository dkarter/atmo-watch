defmodule AtmoWatch.Publisher do
  use GenServer

  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl GenServer
  def init(:ok) do
    {:ok, timer_ref} =
      :timer.seconds(5)
      |> :timer.send_interval(:publish)

    {:ok, %{timer_ref: timer_ref}}
  end

  @impl GenServer
  def handle_info(:publish, state) do
    Logger.debug("Publishing weather conditions")

    readings = AtmoWatch.HumidityTemperatureWorker.get_readings()

    args = %{
      temperature_c: readings[:temperature],
      humidity_percent: readings[:humidity]
    }

    [
      url: url(),
      json: args
    ]
    |> Req.new()
    |> Req.request()
    |> case do
      {:ok, %Req.Response{status: 201}} ->
        Logger.info("Successfully published weather conditions")

      otherwise ->
        Logger.error("Failed to publish weather conditions #{inspect(otherwise)}")
    end

    {:noreply, state}
  end

  defp url do
    System.fetch_env!("SERVER_BASE_URL")
    |> URI.parse()
    |> URI.merge("/api/weather-conditions")
  end
end
