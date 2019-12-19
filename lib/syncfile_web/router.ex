defmodule SyncfileWeb.Router do
  use SyncfileWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SyncfileWeb do
    pipe_through :browser

    get "/", PageController, :new
    put "/", PageController, :update
  end
end
