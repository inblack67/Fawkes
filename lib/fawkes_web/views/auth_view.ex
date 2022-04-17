defmodule FawkesWeb.AuthView do
  use FawkesWeb, :view

  def render("ack.json", %{success: success, message: message}),
    do: %{success: success, message: message}

  def render("ack.json", %{success: success, data: data}), do: %{success: success, data: data}

  def render("login.json", %{success: success, message: message, token: token}),
    do: %{success: success, message: message, token: token}

  def render("errors.json", %{errors: errors}),
    do: %{success: false, errors: errors}
end
