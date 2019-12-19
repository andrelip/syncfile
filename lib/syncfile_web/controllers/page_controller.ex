defmodule SyncfileWeb.PageController do
  use SyncfileWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
