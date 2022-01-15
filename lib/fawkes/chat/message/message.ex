defmodule Fawkes.Chat.Message.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__]}
  schema "messages" do
    field :content, :string
    field :room_id, :id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :room_id])
    |> validate_required([:content, :room_id])
  end
end
