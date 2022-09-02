defmodule Liveboard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Liveboard.Repo,
      # Start the Telemetry supervisor
      LiveboardWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Liveboard.PubSub},
      # Start the Endpoint (http/https)
      LiveboardWeb.Endpoint
      # Start a worker by calling: Liveboard.Worker.start_link(arg)
      # {Liveboard.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Liveboard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveboardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
