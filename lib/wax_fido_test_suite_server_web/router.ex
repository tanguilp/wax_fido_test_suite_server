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
      pub_key_cred_params: [-65535, -259, -258, -257, -39, -38, -37, -36, -35, -8, -7],
      silent_authentication_enabled: true
  end
end
