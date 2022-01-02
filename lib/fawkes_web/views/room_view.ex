defmodule FawkesWeb.RoomView do
  use FawkesWeb, :view

  def render("ack.json", %{success: success, message: message}),
    do: %{success: success, message: message}

  def render("ack.json", %{success: success, data: data}), do: %{success: success, data: data}

  def render("errors.json", %{errors: errors}),
    do: %{success: false, errors: errors}
end
