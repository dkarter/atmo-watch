defmodule AtmoWatchServerWeb.WeatherConditionsController do
  use AtmoWatchServerWeb, :controller

  require Logger

  alias AtmoWatchServer.WeatherConditions

  def create(conn, params) do
    case WeatherConditions.create_entry(params) do
      {:ok, weather_condition} ->
        Logger.debug("Successfully created a weather condition entry")

        conn
        |> put_status(:created)
        |> json(weather_condition)

      error ->
        Logger.warn("Failed to create a weather entry #{inspect(error)}")

        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Poorly formatted payload"})
    end
  end
end
