defmodule Vivvo.ContractsTest do
  use Vivvo.DataCase

  alias Vivvo.Contracts

  describe "contracts" do
    alias Vivvo.Contracts.Contract

    import Vivvo.ContractsFixtures

    @invalid_attrs %{to: nil, from: nil, monthly_rent: nil, payment_day: nil}

    test "list_contracts/0 returns all contracts" do
      contract = contract_fixture()
      assert Contracts.list_contracts() == [contract]
    end

    test "get_contract!/1 returns the contract with given id" do
      contract = contract_fixture()
      assert Contracts.get_contract!(contract.id) == contract
    end

    test "create_contract/1 with valid data creates a contract" do
      valid_attrs = %{to: ~D[2025-12-07], from: ~D[2025-12-07], monthly_rent: "120.5", payment_day: 42}

      assert {:ok, %Contract{} = contract} = Contracts.create_contract(valid_attrs)
      assert contract.to == ~D[2025-12-07]
      assert contract.from == ~D[2025-12-07]
      assert contract.monthly_rent == Decimal.new("120.5")
      assert contract.payment_day == 42
    end

    test "create_contract/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contracts.create_contract(@invalid_attrs)
    end

    test "update_contract/2 with valid data updates the contract" do
      contract = contract_fixture()
      update_attrs = %{to: ~D[2025-12-08], from: ~D[2025-12-08], monthly_rent: "456.7", payment_day: 43}

      assert {:ok, %Contract{} = contract} = Contracts.update_contract(contract, update_attrs)
      assert contract.to == ~D[2025-12-08]
      assert contract.from == ~D[2025-12-08]
      assert contract.monthly_rent == Decimal.new("456.7")
      assert contract.payment_day == 43
    end

    test "update_contract/2 with invalid data returns error changeset" do
      contract = contract_fixture()
      assert {:error, %Ecto.Changeset{}} = Contracts.update_contract(contract, @invalid_attrs)
      assert contract == Contracts.get_contract!(contract.id)
    end

    test "delete_contract/1 deletes the contract" do
      contract = contract_fixture()
      assert {:ok, %Contract{}} = Contracts.delete_contract(contract)
      assert_raise Ecto.NoResultsError, fn -> Contracts.get_contract!(contract.id) end
    end

    test "change_contract/1 returns a contract changeset" do
      contract = contract_fixture()
      assert %Ecto.Changeset{} = Contracts.change_contract(contract)
    end
  end
end
