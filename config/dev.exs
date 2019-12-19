use Mix.Config

config :syncfile, Syncfile.Repo,
  username: System.get_env("PG_USER", "postgres"),
  password: System.get_env("PG_PASSWORD", "postgres"),
  database: "syncfile_dev",
  hostname: System.get_env("PG_HOSTNAME", "localhost"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :syncfile, SyncfileWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :syncfile, SyncfileWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/syncfile_web/{live,views}/.*(ex)$",
      ~r"lib/syncfile_web/templates/.*(eex)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
