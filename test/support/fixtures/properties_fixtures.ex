defmodule Vivvo.PropertiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vivvo.Properties` context.
  """

  @doc """
  Generate a property.
  """
  def property_fixture(attrs \\ %{}) do
    {:ok, property} =
      attrs
      |> Enum.into(%{
        address: "some address",
        area: 42,
        rooms: 42,
        type: :house
      })
      |> Vivvo.Properties.create_property()

    property
  end
end
