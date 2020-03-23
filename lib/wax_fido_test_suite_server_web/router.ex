defmodule WaxFidoTestSuiteServerWeb.Router do
  use WaxFidoTestSuiteServerWeb, :router

  alias WaxFidoTestSuiteServerWeb.UserKeyCallbackImpl

  pipeline :api do
    plug :accepts, ["json"]

    plug Plug.Session, store: :ets, key: "sid", table: :session
  end

  scope "/" do
    forward "/", WaxAPIREST.Plug, callback_module: UserKeyCallbackImpl
  end
end
