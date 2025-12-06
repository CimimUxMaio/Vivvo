defmodule Vivvo.Properties.Property do
  use Ecto.Schema
  import Ecto.Changeset

  schema "properties" do
    field :address, :string
    field :area, :integer
    field :rooms, :integer
    field :type, Ecto.Enum, values: [:house, :flat]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:address, :area, :rooms, :type])
    |> validate_required([:address, :area, :rooms, :type])
  end
end
