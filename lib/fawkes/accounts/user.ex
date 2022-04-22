defmodule Fawkes.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fawkes.Auth.AuthToken

  @derive {Jason.Encoder, except: [:__meta__]}
  schema "users" do
    field(:email, :string)
    field(:password, :string)
    field(:username, :string)

    has_many :auth_tokens, AuthToken

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> validate_length(:password, min: 8, max: 16)
    |> validate_length(:username, min: 5, max: 30)
    |> validate_length(:email, min: 1)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase(&1))
    |> update_change(:username, &String.downcase(&1))
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> hash_password
  end

  defp hash_password(%Ecto.Changeset{} = changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password, Pbkdf2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end

  def verify_password(password, hashed_password),
    do: Pbkdf2.verify_pass(password, hashed_password)
end
