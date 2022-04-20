defmodule FawkesWeb.JWTAuthPlug do
  import Plug.Conn
  alias Fawkes.JWTAuthToken
  alias Fawkes.Accounts
  alias Fawkes.Accounts.User

  def init(opts), do: opts

  def call(conn, _opts) do
    bearer = conn |> Plug.Conn.get_req_header("authorization") |> List.first()
    list = String.split(bearer, " ")
    token = list |> List.last()

    signer = Joken.Signer.create("HS256", "secret")

    with {:ok, %{"user_id" => user_id}} <- JWTAuthToken.verify_and_validate(token, signer),
         %User{} = Accounts.get_user(user_id) do
      conn
    else
      {:error, :signature_error} ->
        conn |> put_status(401) |> halt

      _ ->
        conn |> put_status(401) |> halt
    end
  end
end
