defmodule FawkesWeb.MessageController do
  use FawkesWeb, :controller
  alias FawkesWeb.Utils
  alias Fawkes.Chat.Message, as: MessageRepo
  alias Fawkes.Chat

  def create(conn, params) do
    room_id = params["room_id"]

    if Chat.get_room(room_id) == nil do
      conn |> render("errors.json", %{errors: ["Invalid room_id"]})
    else
      case MessageRepo.create_message(params) do
        {:ok, _message} ->
          conn
          |> render("ack.json", %{success: true, message: "Message created"})

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> render("errors.json", %{errors: Utils.format_changeset_errors(changeset)})

        true ->
          conn
          |> render("ack.json", %{success: false, message: Utils.internal_server_error()})
      end
    end
  end
end
