defmodule Vivvo.TenantsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vivvo.Tenants` context.
  """

  @doc """
  Generate a tenant.
  """
  def tenant_fixture(attrs \\ %{}) do
    {:ok, tenant} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Vivvo.Tenants.create_tenant()

    tenant
  end
end
