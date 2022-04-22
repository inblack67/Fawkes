defmodule Fawkes.AuthFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fawkes.Auth` context.
  """

  @doc """
  Generate a auth_token.
  """
  def auth_token_fixture(attrs \\ %{}) do
    {:ok, auth_token} =
      attrs
      |> Enum.into(%{
        token: "some token"
      })
      |> Fawkes.Auth.create_auth_token()

    auth_token
  end
end
