defmodule FawkesWeb.AuthController do
  use FawkesWeb, :controller
  alias Fawkes.Accounts
  alias FawkesWeb.Utils
  alias Fawkes.JWTAuthToken
  alias Fawkes.Accounts.User
  alias Fawkes.Auth.AuthToken
  alias Fawkes.Repo

  def get(conn, _params) do
    user = conn.assigns.current_user

    conn
    |> render("ack.json", %{
      success: true,
      data: %{
        username: user.username,
        id: user.id
      }
    })
  end

  def create(conn, %{"username" => username, "password" => password}) do
    with %User{} = user <-
           Accounts.get_user_by_username(username),
         true <- User.verify_password(password, user.password) do
      claims = %{"user_id" => "#{user.id}"}

      secret = Application.fetch_env!(:fawkes, :jwt_secret)
      signer = Joken.Signer.create("HS256", secret)

      jwt = JWTAuthToken.generate_and_sign!(claims, signer)

      conn
      |> render("login.json", %{success: true, message: "Logged in", token: jwt})
    else
      _ ->
        conn |> render("ack.json", %{success: false, message: Utils.invalid_credentials()})
    end
  end

  def delete(conn, _params) do
    case Ecto.build_assoc(conn.assigns.current_user, :auth_tokens, %{token: conn.assigns.token}) do
      %AuthToken{} = auth_token ->
        Repo.insert!(auth_token)
        conn |> render("ack.json", %{success: true, message: "Logged Out"})

      _ ->
        conn |> render("ack.json", %{success: false, message: Utils.internal_server_error()})
    end
  end
end
