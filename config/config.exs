# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :shiftplaner_web, ShiftplanerWebWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "I+oTtUWm+0AntnpdA9JR/2wQjACjIxP8oQgx/sACdpTy2aQK9vIXiw4wwtxizZyf",
  render_errors: [view: ShiftplanerWebWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ShiftplanerWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
