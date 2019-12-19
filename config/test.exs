use Mix.Config

config :syncfile, Syncfile.Repo,
  username: System.get_env("PG_USER", "postgres"),
  password: System.get_env("PG_PASSWORD", "postgres"),
  database: "syncfile_test",
  hostname: System.get_env("PG_HOSTNAME", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

config :syncfile, SyncfileWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
