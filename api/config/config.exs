# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :piscine,
  ecto_repos: [Piscine.Repo]

# Configures the endpoint
config :piscine, PiscineWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yGWtxsP3kgLVuEs33gXxu6oElCwwYiMDNaD8u6Lbdusgp59cHtgP9qynBV49/Zij",
  render_errors: [view: PiscineWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Piscine.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :joken,
  default_signer: [
    signer_alg: "RS256",
    key_pem: """
    -----BEGIN RSA PRIVATE KEY-----

    -----END RSA PRIVATE KEY-----
    """
  ]

config :cors_plug,
  origin: [
    "http://localhost:4000",
    "http://localhost:9000",
    "http://localhost:8080",
    "http://localhost:3000",
    "http://localhost:8080/login",
    "http://localhost",
    "http://timemanager.impsdc.fr:4000",
    "https://timemanager.impsdc.fr:4000",
    "http://timemanager.impsdc.fr",
    "https://timemanager.impsdc.fr"
  ]
