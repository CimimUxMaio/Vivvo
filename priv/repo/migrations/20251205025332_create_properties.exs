defmodule Vivvo.Repo.Migrations.CreateProperties do
  use Ecto.Migration

  def change do
    create table(:properties) do
      add :address, :string
      add :area, :integer
      add :rooms, :integer
      add :type, :string

      timestamps(type: :utc_datetime)
    end
  end
end
