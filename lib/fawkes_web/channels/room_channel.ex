defmodule FawkesWeb.RoomChannel do
  use FawkesWeb, :channel
  alias Fawkes.Chat
  alias Fawkes.Chat.Message, as: MessageRepo

  @new_message "new_message"

  def join("room:" <> room_id, _payload, socket) do
    room = Chat.get_room(room_id)

    if room == nil do
      {:error, socket}
    else
      {:ok, assign(socket, :room_id, room_id)}
    end
  end

  def handle_in(@new_message, %{"payload" => %{"content" => content}}, socket) do
    room_id = socket.assigns.room_id

    case MessageRepo.create_message(%{content: content, room_id: room_id}) do
      {:ok, message} ->
        broadcast!(socket, @new_message, %{payload: %{message: message}})

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = _changeset} ->
        {:noreply, socket}

      true ->
        {:noreply, socket}
    end
  end

  def handle_in(@new_message, _payload, socket) do
    {:noreply, socket}
  end
end
