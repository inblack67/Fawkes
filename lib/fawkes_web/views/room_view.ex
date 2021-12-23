defmodule FawkesWeb.RoomView do
  use FawkesWeb, :view

  def render("ack.json", %{success: success, message: message}),
    do: %{success: success, message: message}

  def render("errors.json", %{success: success, errors: errors}),
    do: %{success: success, errors: errors}
end
