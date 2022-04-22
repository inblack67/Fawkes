defmodule Fawkes.AuthTest do
  use Fawkes.DataCase

  alias Fawkes.Auth

  describe "auth_tokens" do
    alias Fawkes.Auth.AuthToken

    import Fawkes.AuthFixtures

    @invalid_attrs %{token: nil}

    test "list_auth_tokens/0 returns all auth_tokens" do
      auth_token = auth_token_fixture()
      assert Auth.list_auth_tokens() == [auth_token]
    end

    test "get_auth_token!/1 returns the auth_token with given id" do
      auth_token = auth_token_fixture()
      assert Auth.get_auth_token!(auth_token.id) == auth_token
    end

    test "create_auth_token/1 with valid data creates a auth_token" do
      valid_attrs = %{token: "some token"}

      assert {:ok, %AuthToken{} = auth_token} = Auth.create_auth_token(valid_attrs)
      assert auth_token.token == "some token"
    end

    test "create_auth_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_auth_token(@invalid_attrs)
    end

    test "update_auth_token/2 with valid data updates the auth_token" do
      auth_token = auth_token_fixture()
      update_attrs = %{token: "some updated token"}

      assert {:ok, %AuthToken{} = auth_token} = Auth.update_auth_token(auth_token, update_attrs)
      assert auth_token.token == "some updated token"
    end

    test "update_auth_token/2 with invalid data returns error changeset" do
      auth_token = auth_token_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_auth_token(auth_token, @invalid_attrs)
      assert auth_token == Auth.get_auth_token!(auth_token.id)
    end

    test "delete_auth_token/1 deletes the auth_token" do
      auth_token = auth_token_fixture()
      assert {:ok, %AuthToken{}} = Auth.delete_auth_token(auth_token)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_auth_token!(auth_token.id) end
    end

    test "change_auth_token/1 returns a auth_token changeset" do
      auth_token = auth_token_fixture()
      assert %Ecto.Changeset{} = Auth.change_auth_token(auth_token)
    end
  end
end
