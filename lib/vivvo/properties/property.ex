defmodule Vivvo.Properties.Property do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Vivvo.Contracts.Contract

  schema "properties" do
    field :address, :string
    field :area, :integer
    field :rooms, :integer
    field :type, Ecto.Enum, values: [:house, :apartment]

    belongs_to :contract, Contract

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:address, :area, :rooms, :type])
    |> cast_assoc(:contract)
    |> validate_required([:address, :area, :rooms, :type])
    |> validate_number(:area, greater_than: 0)
    |> validate_number(:rooms, greater_than: 0)
  end
end
