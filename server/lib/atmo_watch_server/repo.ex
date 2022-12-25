defmodule AtmoWatchServer.Repo do
  use Ecto.Repo,
    otp_app: :atmo_watch_server,
    adapter: Ecto.Adapters.Postgres
end
