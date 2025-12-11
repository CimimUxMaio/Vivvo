# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Vivvo.Repo.insert!(%Vivvo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Vivvo.Properties
alias Vivvo.Tenants

# Create properties

{:ok, tenant1} =
  Tenants.create_tenant(%{
    name: "John Doe"
  })

{:ok, tenant2} =
  Tenants.create_tenant(%{
    name: "Jane Smith"
  })

Properties.create_property(%{
  address: "Av. Libertador 2450",
  area: 75,
  rooms: 3,
  type: :apartment,
  contract: %{
    from: ~D[2025-01-01],
    to: ~D[2027-12-31],
    monthly_rent: 300_000,
    payment_day: 5,
    tenant_id: tenant1.id
  }
})

Properties.create_property(%{
  address: "Cordoba 1120",
  area: 32,
  rooms: 1,
  type: :apartment
})

Properties.create_property(%{
  address: "Sucre 850",
  area: 140,
  rooms: 4,
  type: :house,
  contract: %{
    from: ~D[2025-06-20],
    to: ~D[2027-12-31],
    monthly_rent: 650_000,
    payment_day: 10,
    tenant_id: tenant2.id
  }
})
