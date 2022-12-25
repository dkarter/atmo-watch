defmodule AtmoWatchServer.Repo.Migrations.CreateWeatherConditions do
  use Ecto.Migration

  def change do
    execute(
      """
      create extension if not exists timescaledb
      """,
      """
      drop extension if exists timescaledb
      """
    )

    create table(:weather_conditions, primary_key: false) do
      add(:timestamp, :naive_datetime, null: false)
      add(:temperature_c, :decimal, null: false)
      add(:humidity_percent, :decimal, null: false)
    end

    execute(
      """
      select create_hypertable('weather_conditions', 'timestamp')
      """,
      """
      """
    )
  end
end
