defmodule AtmoWatchServer.WeatherConditionsTest do
  use AtmoWatchServer.DataCase, async: true

  alias AtmoWatchServer.WeatherConditions
  alias AtmoWatchServer.WeatherConditions.WeatherCondition

  describe "create_entry/1" do
    test "creates the record when all required params are supplied" do
      assert {:ok, result} =
               WeatherConditions.create_entry(%{
                 temperature_c: 10.5,
                 humidity_percent: 22.1
               })

      temp = Decimal.new("10.5")
      hum = Decimal.new("22.1")

      assert %WeatherCondition{
               temperature_c: ^temp,
               humidity_percent: ^hum
             } = result
    end

    test "returns an error when missing required params" do
      assert {:error, changeset} =
               WeatherConditions.create_entry(%{
                 humidity_percent: 22.1
               })

      assert %{temperature_c: ["can't be blank"]} == errors_on(changeset)
    end
  end
end
