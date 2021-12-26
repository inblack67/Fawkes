defmodule FawkesWeb.Utils do
  import Ecto.Changeset

  @internal_server_error "Internal Server Error"

  def internal_server_error, do: @internal_server_error

  def format_changeset_errors(%Ecto.Changeset{} = changeset) do
    errors =
      traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    formatted_errors =
      Enum.map(errors, fn {key, value} ->
        formatted_error = "#{key} #{value}"
        formatted_error
      end)

    formatted_errors
  end
end
