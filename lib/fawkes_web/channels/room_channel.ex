defmodule FawkesWeb.RoomChannel do
  use FawkesWeb, :channel

  @new_message "new_message"

  def join("room:" <> room_id, _params, socket) do
    IO.inspect("joined room with id => #{room_id}")
    {:ok, assign(socket, :room_id, room_id)}
  end

  def handle_in(@new_message, payload, socket) do
    IO.inspect("#{@new_message} event payload")
    IO.inspect(payload)
    IO.inspect("assign")
    IO.inspect(socket.assigns)
    # broadcast!(socket, @new_message, payload)
    {:noreply, socket}
  end
end
