defmodule AtmoWatch.Router do
  use Plug.Router

  import Plug.Conn

  plug :match

  plug Plug.Parsers,
    parsers: [:urlencoded, :json, :multipart],
    json_decoder: Jason

  plug :dispatch

  plug PromEx.Plug, prom_ex_module: AtmoWatch.PromEx

  get "/ping" do
    conn
    |> text("pong")
  end

  get "/debug" do
    resp = inspect(conn, limit: :infinity, pretty: true)

    conn
    |> text(resp)
  end

  get "/environment" do
    readings = AtmoWatch.HumidityTemperatureWorker.get_readings()

    conn
    |> json(readings)
  end

  match _ do
    conn
    |> json(%{error: "not found"}, :not_found)
  end

  defp json(conn, response, status \\ :ok) do
    json = Jason.encode!(response)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, json)
  end

  defp text(conn, response, status \\ :ok) do
    conn
    |> put_resp_content_type("application/text")
    |> send_resp(status, response)
  end
end
