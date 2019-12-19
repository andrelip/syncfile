use Mix.Config

config :syncfile,
  ecto_repos: [Syncfile.Repo]

config :syncfile, SyncfileWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3viRkvsJwlbCdoXmfV7bgMOXOG4KGsl1PJCAzbmT/lEaqeNWpL9jmK69NLboJWR2",
  render_errors: [view: SyncfileWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Syncfile.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
