defmodule Vivvo.PropertiesTest do
  use Vivvo.DataCase

  alias Vivvo.Properties

  describe "properties" do
    alias Vivvo.Properties.Property

    import Vivvo.PropertiesFixtures

    @invalid_attrs %{type: nil, address: nil, area: nil, rooms: nil}

    test "list_properties/0 returns all properties" do
      property = property_fixture()
      assert Properties.list_properties() == [property]
    end

    test "get_property!/1 returns the property with given id" do
      property = property_fixture()
      assert Properties.get_property!(property.id) == property
    end

    test "create_property/1 with valid data creates a property" do
      valid_attrs = %{type: :house, address: "some address", area: 42, rooms: 42}

      assert {:ok, %Property{} = property} = Properties.create_property(valid_attrs)
      assert property.type == :house
      assert property.address == "some address"
      assert property.area == 42
      assert property.rooms == 42
    end

    test "create_property/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Properties.create_property(@invalid_attrs)
    end

    test "update_property/2 with valid data updates the property" do
      property = property_fixture()
      update_attrs = %{type: :flat, address: "some updated address", area: 43, rooms: 43}

      assert {:ok, %Property{} = property} = Properties.update_property(property, update_attrs)
      assert property.type == :flat
      assert property.address == "some updated address"
      assert property.area == 43
      assert property.rooms == 43
    end

    test "update_property/2 with invalid data returns error changeset" do
      property = property_fixture()
      assert {:error, %Ecto.Changeset{}} = Properties.update_property(property, @invalid_attrs)
      assert property == Properties.get_property!(property.id)
    end

    test "delete_property/1 deletes the property" do
      property = property_fixture()
      assert {:ok, %Property{}} = Properties.delete_property(property)
      assert_raise Ecto.NoResultsError, fn -> Properties.get_property!(property.id) end
    end

    test "change_property/1 returns a property changeset" do
      property = property_fixture()
      assert %Ecto.Changeset{} = Properties.change_property(property)
    end
  end
end
