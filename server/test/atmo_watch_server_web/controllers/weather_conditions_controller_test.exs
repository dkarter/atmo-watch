defmodule AtmoWatchServerWeb.Controllers.WeatherConditionsControllerTest do
  use AtmoWatchServerWeb.ConnCase, async: true

  import ExUnit.CaptureLog, only: [with_log: 1]

  describe "POST /api/weather-conditions" do
    setup do
      {:ok, %{route: ~p"/api/weather-conditions"}}
    end

    test "creates a record when valid payload is supplied", ctx do
      conn =
        ctx.conn
        |> post(ctx.route, %{temperature_c: "12.3", humidity_percent: "5"})

      assert %{
               "humidity_percent" => "5",
               "temperature_c" => "12.3"
             } == json_response(conn, :created)
    end

    test "returns an error when invalid payload is supplied", ctx do
      {conn, log} =
        with_log(fn ->
          ctx.conn
          |> post(ctx.route, %{})
        end)

      assert %{"message" => "Poorly formatted payload"} =
               json_response(conn, :unprocessable_entity)

      assert log =~ "Failed to create a weather entry"
    end
  end
end
