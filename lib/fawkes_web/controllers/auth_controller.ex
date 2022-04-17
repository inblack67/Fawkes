defmodule FawkesWeb.AuthController do
  use FawkesWeb, :controller
  alias Fawkes.Accounts
  alias FawkesWeb.Utils

  def get(conn, _params) do
    if Guardian.Plug.authenticated?(conn) do
      user = Guardian.Plug.current_resource(conn)
      IO.inspect(user)
    else
      # No user
    end

    conn |> render("ack.json", %{success: true, message: "ok"})
  end

  def create(conn, params) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        {:ok, jwt, _claims} = Guardian.encode_and_sign(user, :access)
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
    if Guardian.Plug.authenticated?(conn) do
      user = Guardian.Plug.current_resource(conn)
      IO.inspect(user)
    else
    end
    conn |> render("ack.json", %{success: true, message: "ok"})
  end
end
