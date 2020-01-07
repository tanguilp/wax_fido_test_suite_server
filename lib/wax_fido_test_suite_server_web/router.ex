defmodule WaxFidoTestSuiteServerWeb.Router do
  use WaxFidoTestSuiteServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WaxFidoTestSuiteServerWeb do
    pipe_through :api
  end
end
