defmodule Fawkes.ChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fawkes.Chat` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        desc: "some desc",
        name: "some name"
      })
      |> Fawkes.Chat.create_room()

    room
  end
end
