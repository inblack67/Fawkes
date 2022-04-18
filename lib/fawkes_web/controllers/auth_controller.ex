defmodule FawkesWeb.AuthController do
  use FawkesWeb, :controller
  alias Fawkes.Accounts
  alias FawkesWeb.Utils
  alias Fawkes.JWTAuthToken

  def get(conn, _params) do
    conn |> render("ack.json", %{success: true, message: "ok"})
  end

  def create(conn, params) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        claims = %{"user_id" => "#{user.id}"}
        jwt = JWTAuthToken.generate_and_sign!(claims)

        conn
        |> render("login.json", %{success: true, message: "Logged in", token: jwt})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("errors.json", %{errors: Utils.format_changeset_errors(changeset)})

      true ->
        conn
        |> render("ack.json", %{success: false, message: Utils.internal_server_error()})
    end
  end

  def delete(conn, _params) do
    conn |> render("ack.json", %{success: true, message: "ok"})
  end
end
