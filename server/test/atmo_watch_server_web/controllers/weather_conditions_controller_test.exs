defmodule AtmoWatchServerWeb.Controllers.WeatherConditionsControllerTest do
  use AtmoWatchServerWeb.ConnCase, async: true

  import ExUnit.CaptureLog, only: [with_log: 1]

  # TODO: use verified routes
  describe "POST /api/weather-conditions" do
    @route "/api/weather-conditions"

    test "creates a record when valid payload is supplied", ctx do
      conn =
        ctx.conn
        |> post(@route, %{temperature_c: "12.3", humidity_percent: "5"})

      assert %{
               "humidity_percent" => "5",
               "temperature_c" => "12.3"
             } == json_response(conn, :created)
    end

    test "returns an error when invalid payload is supplied", ctx do
      {conn, log} =
        with_log(fn ->
          ctx.conn
          |> post(@route, %{})
        end)

      assert %{"message" => "Poorly formatted payload"} =
               json_response(conn, :unprocessable_entity)

      assert log =~ "Failed to create a weather entry"
    end
  end
end
