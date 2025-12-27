defmodule AtmoWatch.MixProject do
  use Mix.Project

  @app :atmo_watch
  @version "0.1.0"
  @all_targets [:rpi0]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.17",
      archives: [nerves_bootstrap: "~> 1.13"],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [{@app, release()}]
    ]
  end

  def cli do
    [preferred_targets: [run: :host, test: :host]]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {AtmoWatch.Application, []},
      extra_applications: [:logger, :runtime_tools, :inets]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:circuits_gpio, "~> 2.1"},
      {:circuits_spi, "~> 2.0"},
      {:dht, "~> 0.1"},
      {:nerves, "~> 1.12.0", runtime: false},
      {:nerves_pack, "~> 0.7.1", targets: @all_targets},
      {:nerves_runtime, "~> 0.13.8", targets: @all_targets},
      {:nerves_system_rpi0, "~> 1.29", runtime: false, targets: :rpi0},
      {:plug, "~> 1.16"},
      {:plug_cowboy, "~> 2.7"},
      {:prom_ex, "~> 1.11"},
      {:req, "~> 0.5"},
      {:ring_logger, "~> 0.11"},
      {:shoehorn, "~> 0.9.1"},
      {:toolshed, "~> 0.4"}
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end
