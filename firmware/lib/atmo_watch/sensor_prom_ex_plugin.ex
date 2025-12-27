defmodule AtmoWatch.SensorPromExPlugin do
  @moduledoc """
  PromEx plugin for reporting sensor readings (temperature and humidity).
  """
  use PromEx.Plugin

  @impl true
  def event_metrics(_opts) do
    [
      sensor_metrics()
    ]
  end

  defp sensor_metrics do
    Event.build(
      :atmo_watch_sensor_event_metrics,
      [
        last_value(
          [:atmo_watch, :sensor, :reading, :temperature],
          event_name: [:atmo_watch, :sensor, :reading],
          description: "The current temperature reading in degrees Celsius",
          measurement: :temperature,
          tags: [:sensor_type],
          unit: :celsius
        ),
        last_value(
          [:atmo_watch, :sensor, :reading, :humidity],
          event_name: [:atmo_watch, :sensor, :reading],
          description: "The current humidity reading as a percentage",
          measurement: :humidity,
          tags: [:sensor_type],
          unit: :percent
        )
      ]
    )
  end
end
