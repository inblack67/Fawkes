defmodule Fawkes.Auth.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fawkes.Accounts.User

  schema "auth_tokens" do
    field :token, :string
    # field :user_id, :id


    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token])
    |> validate_required([:token])
  end
end
