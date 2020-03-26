defmodule WaxFidoTestSuiteServerWeb.Router do
  use WaxFidoTestSuiteServerWeb, :router

  alias WaxFidoTestSuiteServerWeb.UserKeyCallbackImpl

  pipeline :api do
    plug :accepts, ["json"]

    plug Plug.Session, store: :ets, key: "sid", table: :session
  end

  scope "/" do
    forward "/", WaxAPIREST.Plug,
      callback_module: UserKeyCallbackImpl,
      pub_key_cred_params: [-39, -38, -37, -36, -35, -7],
      silent_authentication_enabled: true
  end
end
