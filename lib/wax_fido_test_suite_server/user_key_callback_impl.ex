defmodule WaxFidoTestSuiteServerWeb.UserKeyCallbackImpl do
  @behaviour WaxAPIREST.Callback

  @impl true
  def user_info(conn, request) do
    %{id: user_id(conn, request)}
  end

  @impl true
  def put_challenge(conn, challenge, request) do
    conn
    |> Plug.Conn.fetch_session()
    |> Plug.Conn.put_session(:wax_api_rest_challenge, challenge)
    |> Plug.Conn.put_session(:user_id, user_id(conn, request))
  end

  @impl true
  def get_challenge(conn) do
    conn
    |> Plug.Conn.fetch_session()
    |> Plug.Conn.get_session(:wax_api_rest_challenge) || raise "Challenge not found in session"
  end

  @impl true
  def register_key(conn, key_id, authenticator_data, _attestation_result) do
    true = :ets.insert(:wax_fido_test_user_keys, {
      user_id(conn),
      key_id,
      authenticator_data.attested_credential_data.credential_public_key
    })

    conn
  end

  @impl true
  def user_keys(conn, request) do
    :ets.lookup(:wax_fido_test_user_keys, user_id(conn, request))
    |> Enum.reduce(
      %{},
      fn {_user_id, key_id, cose_key}, acc -> Map.put(acc, key_id, cose_key) end
    )
  end

  @impl true
  def on_authentication_success(conn, _authenticator_metadata) do
    conn
  end

  defp user_id(conn) do
    conn
    |> Plug.Conn.fetch_session()
    |> Plug.Conn.get_session(:user_id)
  end

  defp user_id(_conn, request) do
    request.username
  end
end
