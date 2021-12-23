defmodule FawkesWeb.RoomController do
  use FawkesWeb, :controller
  alias Fawkes.Chat
  alias FawkesWeb.Utils

  def greet(conn, _params) do
    conn
    |> render("ack.json", %{success: true, message: "API up and running"})
  end

  def create(conn, params) do
    case Chat.create_room(params) do
      {:ok, _room} ->
        conn
        |> render("ack.json", %{success: true, message: "Room created"})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("errors.json", %{
          success: false,
          errors: Utils.format_changeset_errors(changeset)
        })

      true ->
        conn |> render("errors.json", %{success: false, errors: ["Internal Server Error"]})
    end
  end
end
