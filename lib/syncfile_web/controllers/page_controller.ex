defmodule SyncfileWeb.PageController do
  use SyncfileWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def update(conn, _params) do
    render(conn, "new.html")
  end
end
