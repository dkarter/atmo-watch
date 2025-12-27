defmodule AtmoWatch.PromEx do
  use PromEx, otp_app: :atmo_watch

  alias PromEx.Plugins

  @impl true
  def plugins do
    [
      # PromEx built in plugins
      Plugins.Application,
      Plugins.Beam

      # Add your own PromEx metrics plugins
      # AtmoWatch.Users.PromExPlugin
    ]
  end

  @impl true
  def dashboard_assigns do
    [
      datasource_id: "1234",
      default_selected_interval: "30s"
    ]
  end

  @impl true
  def dashboards do
    [
      # PromEx built in Grafana dashboards
      {:prom_ex, "application.json"},
      {:prom_ex, "beam.json"}

      # Add your dashboard definitions here with the format: {:otp_app, "path_in_priv"}
      # {:atmo_watch, "/grafana_dashboards/user_metrics.json"}
    ]
  end
end
