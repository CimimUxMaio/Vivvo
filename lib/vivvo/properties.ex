defmodule Vivvo.Properties do
  @moduledoc """
  The Properties context.
  """
  import Ecto.Query, warn: false

  alias Vivvo.Properties.Property

  alias Vivvo.Repo

  @doc """
  Returns the list of properties.

  ## Examples

      iex> list_properties()
      [%Property{}, ...]

  """
  def list_properties(params \\ %{}) do
    from(p in Property, preload: [contract: :tenant])
    |> filter_by_status(params["status"])
    |> filter_by_term(params["term"])
    |> sort_by(params["sort_by"])
    |> Repo.all()
  end

  @doc """
  Gets a single property.

  Raises `Ecto.NoResultsError` if the Property does not exist.

  ## Examples

      iex> get_property!(123)
      %Property{}

      iex> get_property!(456)
      ** (Ecto.NoResultsError)

  """
  def get_property!(id), do: Repo.get!(Property, id) |> Repo.preload(contract: :tenant)

  @doc """
  Creates a property.

  ## Examples

      iex> create_property(%{field: value})
      {:ok, %Property{}}

      iex> create_property(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_property(attrs) do
    %Property{}
    |> Property.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a property.

  ## Examples

      iex> update_property(property, %{field: new_value})
      {:ok, %Property{}}

      iex> update_property(property, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_property(%Property{} = property, attrs) do
    property
    |> Property.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a property.

  ## Examples

      iex> delete_property(property)
      {:ok, %Property{}}

      iex> delete_property(property)
      {:error, %Ecto.Changeset{}}

  """
  def delete_property(%Property{} = property) do
    Repo.delete(property)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking property changes.

  ## Examples

      iex> change_property(property)
      %Ecto.Changeset{data: %Property{}}

  """
  def change_property(%Property{} = property, attrs \\ %{}) do
    Property.changeset(property, attrs)
  end

  def create_contract(property, contract_attrs) do
    update_property(property, %{"contract" => contract_attrs})
  end

  # Filters

  defp filter_by_status(query, all) when all in [nil, "all", ""], do: query

  defp filter_by_status(query, "occupied") do
    from p in query,
      where: not is_nil(p.contract_id)
  end

  defp filter_by_status(query, "vacant") do
    from p in query,
      where: is_nil(p.contract_id)
  end

  defp filter_by_term(query, nil), do: query

  defp filter_by_term(query, term) do
    like_term = "%#{term}%"

    from p in query,
      where: ilike(p.address, ^like_term)
  end

  defp sort_by(query, "newest") do
    from(p in query,
      order_by: [desc: p.inserted_at]
    )
  end

  defp sort_by(query, "oldest") do
    from(p in query,
      order_by: [asc: p.inserted_at]
    )
  end

  defp sort_by(query, _), do: sort_by(query, "newest")
end
