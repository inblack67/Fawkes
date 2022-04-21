defmodule FawkesWeb.JWTAuthPlug do
  import Plug.Conn
  alias Fawkes.JWTAuthToken
  alias Fawkes.Accounts
  alias Fawkes.Accounts.User

  def init(opts), do: opts

  def call(conn, _opts) do
    secret = Application.fetch_env!(:fawkes, :jwt_secret)
    bearer = conn |> Plug.Conn.get_req_header("authorization") |> List.first()

    if bearer == nil do
      conn |> put_status(401) |> halt
    else
      list = String.split(bearer, " ")
      token = list |> List.last()

      signer = Joken.Signer.create("HS256", secret)

      with {:ok, %{"user_id" => user_id}} <- JWTAuthToken.verify_and_validate(token, signer),
           %User{} = user <- Accounts.get_user(user_id) do
        conn
        |> assign(:current_user, user)
      else
        {:error, :signature_error} ->
          conn |> put_status(401) |> halt

        _ ->
          conn |> put_status(401) |> halt
      end
    end
  end
end
