defmodule VivvoWeb.PropertyLive.Helpers do
  @moduledoc false
  use Phoenix.Component

  alias Vivvo.Properties.Property

  # Components

  attr :class, :string, default: ""
  attr :property, :map, required: true

  def status_badge(%{property: property} = assigns) do
    status = property_status(property)
    status_class = status_class(status)

    assigns =
      assigns
      |> Map.put(:status, status)
      |> Map.put(:status_class, status_class)

    ~H"""
    <span class={["badge badge-soft", @status_class, @class]}>{@status}</span>
    """
  end

  # Function helpers

  def property_status(_property) do
    Enum.random(["Occupied", "Vacant"])
  end

  defp status_class("Occupied"), do: "badge-success"
  defp status_class("Vacant"), do: "badge-warning"

  def property_category(%Property{type: :house}), do: "House"
  def property_category(%Property{rooms: 1}), do: "Studio"
  def property_category(%Property{rooms: rooms}), do: "#{rooms} rooms"

  def property_summary(property) do
    category = property_category(property)
    "#{category} · #{property.area} m²"
  end
end
