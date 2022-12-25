defmodule AtmoWatchServer.WeatherConditions.WeatherCondition do
  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
          timestamp: NaiveDateTime.t() | nil,
          temperature_c: number() | nil,
          humidity_percent: number() | nil
        }

  @permitted_fields [
    :temperature_c,
    :humidity_percent
  ]

  @derive {Jason.Encoder, only: @permitted_fields}

  @primary_key false
  schema "weather_conditions" do
    field(:timestamp, :naive_datetime)
    field(:temperature_c, :decimal)
    field(:humidity_percent, :decimal)
  end

  @spec create_changeset(t(), map()) :: Ecto.Changeset.t()
  def create_changeset(weather_conditions = %__MODULE__{}, attrs) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    weather_conditions
    |> cast(attrs, @permitted_fields)
    |> validate_required(@permitted_fields)
    |> put_change(:timestamp, timestamp)
  end
end
