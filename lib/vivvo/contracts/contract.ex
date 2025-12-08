defmodule Vivvo.Contracts.Contract do
  use Ecto.Schema
  import Ecto.Changeset

  alias Vivvo.Tenants.Tenant

  schema "contracts" do
    field :from, :date
    field :to, :date
    field :monthly_rent, :decimal
    field :payment_day, :integer

    belongs_to :tenant, Tenant

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contract, attrs) do
    contract
    |> cast(attrs, [:from, :to, :monthly_rent, :payment_day, :tenant_id])
    |> validate_required([:from, :monthly_rent, :payment_day, :tenant_id])
    |> validate_number(:payment_day, greater_than: 0, less_than: 20)
    |> validate_number(:monthly_rent, greater_than: 0)
    |> validate_date_range()
  end

  defp validate_date_range(changeset) do
    from = get_field(changeset, :from)
    to = get_field(changeset, :to)

    if from && to && Date.compare(from, to) not in [:lt, :eq] do
      add_error(changeset, :to, "end date should be after start date")
    else
      changeset
    end
  end
end
