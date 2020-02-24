# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :wax_fido_test_suite_server, WaxFidoTestSuiteServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3xg/BlMjL4pa3ldH990IrbkYAz8fvvrkbrQsolPTM6E9oGOYhBru+YdTnPQK3IjE",
  render_errors: [view: WaxFidoTestSuiteServerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: WaxFidoTestSuiteServer.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :wax, :origin, "https://www.example.com"
config :wax, :rp_id, :auto

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
