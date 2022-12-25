defmodule AtmoWatchServer.WeatherConditions do
  alias AtmoWatchServer.Repo
  alias AtmoWatchServer.WeatherConditions.WeatherCondition

  def create_entry(attrs) do
    %WeatherCondition{}
    |> WeatherCondition.create_changeset(attrs)
    |> Repo.insert()
  end
end
