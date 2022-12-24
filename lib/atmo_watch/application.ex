defmodule AtmoWatch.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AtmoWatch.Supervisor]

    # TODO: extract all of the server setup to config
    port = if target() == :host, do: 4001, else: 80

    children =
      [
        # Children for all targets
        # Starts a worker by calling: AtmoWatch.Worker.start_link(arg)
        {AtmoWatch.CommWorker, []},
        {Plug.Cowboy,
         [
           scheme: :http,
           plug: AtmoWatch.Router,
           options: [port: port]
         ]}
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: AtmoWatch.Worker.start_link(arg)
      # {AtmoWatch.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      {AtmoWatch.HumidityTemperatureWorker, []}
    ]
  end

  def target() do
    Application.get_env(:atmo_watch, :target)
  end
end
