defmodule AtmoWatch.HumidityTemperatureWorker do
  use GenServer

  require Logger

  @pin 21

  # ============ API
  def get_readings do
    GenServer.call(__MODULE__, :get_readings)
  end

  # ============ Server

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl GenServer
  def init([]) do
    {:ok, timer_ref} =
      :timer.seconds(5)
      |> :timer.send_interval(:poll_dht)

    {:ok, %{timer_ref: timer_ref, readings: nil}}
  end

  @impl GenServer
  def handle_info(:poll_dht, state) do
    DHT.read(@pin, :dht11)
    |> case do
      {:ok, reading} ->
        {:noreply, Map.put(state, :readings, reading)}

      {:error, reason} ->
        Logger.error("Failed to read humidity and temperature: #{inspect(reason)}")

        {:noreply, state}
    end
  end

  @impl GenServer
  def handle_call(:get_readings, _caller, state) do
    {:reply, state.readings, state}
  end
end
