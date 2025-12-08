defmodule Vivvo.Repo.Migrations.CreateContracts do
  use Ecto.Migration

  def change do
    create table(:contracts) do
      add :from, :date
      add :to, :date
      add :monthly_rent, :decimal
      add :payment_day, :integer
      add :tenant_id, references(:tenants, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    alter table(:properties) do
      add :contract_id, references(:contracts, on_delete: :delete_all)
    end

    create index(:contracts, [:tenant_id])
  end
end
