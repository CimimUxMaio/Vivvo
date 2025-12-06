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

# Create properties

Properties.create_property(%{
  address: "Av. Libertador 2450",
  area: 75,
  rooms: 3,
  type: :flat
})

Properties.create_property(%{
  address: "Cordoba 1120",
  area: 32,
  rooms: 1,
  type: :flat
})

Properties.create_property(%{
  address: "Sucre 850",
  area: 140,
  rooms: 4,
  type: :house
})

Properties.create_property(%{
  address: "Corrientes 1200",
  area: 60,
  rooms: 2,
  type: :flat
})
