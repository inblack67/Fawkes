defmodule FawkesWeb.UserController do
  use FawkesWeb, :controller
  alias Fawkes.Accounts
  alias FawkesWeb.Utils

  def create(conn, params) do
    case Accounts.create_user(params) do
      {:ok, _user} ->
        conn |> render("ack.json", %{success: true, message: "Registeration successful"})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> render("errors.json", %{errors: Utils.format_changeset_errors(changeset)})

      true ->
        conn |> render("ack.json", %{success: false, message: Utils.internal_server_error()})
    end
  end
end
