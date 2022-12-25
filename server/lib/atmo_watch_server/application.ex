defmodule AtmoWatchServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AtmoWatchServerWeb.Telemetry,
      # Start the Ecto repository
      AtmoWatchServer.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: AtmoWatchServer.PubSub},
      # Start Finch
      {Finch, name: AtmoWatchServer.Finch},
      # Start the Endpoint (http/https)
      AtmoWatchServerWeb.Endpoint
      # Start a worker by calling: AtmoWatchServer.Worker.start_link(arg)
      # {AtmoWatchServer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AtmoWatchServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AtmoWatchServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
