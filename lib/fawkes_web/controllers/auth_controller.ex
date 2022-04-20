defmodule FawkesWeb.AuthController do
  use FawkesWeb, :controller
  alias Fawkes.Accounts
  alias FawkesWeb.Utils
  alias Fawkes.JWTAuthToken
  alias Fawkes.Accounts.User

  def get(conn, _params) do
    conn |> render("ack.json", %{success: true, message: "ok"})
  end

  def create(conn, %{"username" => username, "password" => password}) do
    with %User{} = user <-
           Accounts.get_user_by_username(username),
         true <- User.verify_password(password, user.password) do
      claims = %{"user_id" => "#{user.id}"}

      signer = Joken.Signer.create("HS256", "secret")

      jwt = JWTAuthToken.generate_and_sign!(claims, signer)

      conn
      |> render("login.json", %{success: true, message: "Logged in", token: jwt})
    else
      _ ->
        conn |> render("ack.json", %{success: false, message: Utils.invalid_credentials()})
    end
  end

  def delete(conn, _params) do
    conn |> render("ack.json", %{success: true, message: "ok"})
  end
end
