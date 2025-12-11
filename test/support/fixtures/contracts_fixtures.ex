defmodule Vivvo.ContractsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vivvo.Contracts` context.
  """

  @doc """
  Generate a contract.
  """
  def contract_fixture(attrs \\ %{}) do
    {:ok, contract} =
      attrs
      |> Enum.into(%{
        from: ~D[2025-12-07],
        monthly_rent: "120.5",
        payment_day: 42,
        to: ~D[2025-12-07]
      })
      |> Vivvo.Contracts.create_contract()

    contract
  end
end
