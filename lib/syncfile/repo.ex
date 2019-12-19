defmodule Syncfile.Repo do
  use Ecto.Repo,
    otp_app: :syncfile,
    adapter: Ecto.Adapters.Postgres
end
