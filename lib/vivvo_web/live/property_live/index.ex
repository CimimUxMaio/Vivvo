defmodule VivvoWeb.PropertyLive.Index do
  use VivvoWeb, :live_view

  alias Vivvo.Properties
  alias Vivvo.Properties.Property

  @impl true
  def render(assigns) do
    ~H"""
    <main class="flex flex-col gap-6">
      <section class="w-full">
        <div class="flex flex-row items-center justify-between gap-3">
          <input
            type="text"
            placeholder="Search properties..."
            class="input w-1/2"
          />

          <div class="flex items-center gap-2">
            <select class="select">
              <option :for={{label, value} <- status_options()} value={value}>
                {label}
              </option>
            </select>

            <select class="select">
              <option :for={{label, value} <- sort_options()} value={value}>
                {label}
              </option>
            </select>
          </div>
        </div>
      </section>

      <section class="w-full grid grid-cols-3 gap-5">
        <.property_card :for={{id, property} <- @streams.properties} property={property} id="id" />
      </section>
    </main>
    """
  end

  def property_card(assigns) do
    status = porperty_status(assigns.property)

    badge_type =
      case status do
        "Occupied" -> "success"
        "Vacant" -> "warning"
      end

    category = property_category(assigns.property)

    assigns =
      assigns
      |> Map.put(:status, status)
      |> Map.put(:badge_type, badge_type)
      |> Map.put(:category, category)

    ~H"""
    <a
      href="#"
      class="card bg-base-100 shadow hover:shadow-md transition"
    >
      <figure class="h-40 w-full overflow-hidden">
        <img
          src="https://www.contenedoresmaracana.com/wp-content/plugins/elementor/assets/images/placeholder.png"
          alt="Property"
          class="w-full h-full object-cover"
        />
      </figure>

      <div class="card-body p-5 space-y-1">
        <div class="flex items-center justify-between">
          <h3 class="card-title font-semibold text-lg">{@property.address}</h3>
          <span class={"badge badge-soft badge-#{@badge_type}"}>{@status}</span>
        </div>

        <p class="text-sm text-base-content/70">{@category} · {@property.area} m²</p>

        <div class="flex justify-between items-center text-sm">
          <%= if @status == "Occupied" do %>
            <span>Next payment: <strong>Feb 10</strong></span>
          <% else %>
            <span>No active lease</span>
          <% end %>
          <span class="text-accent font-medium">1 receipt</span>
        </div>
      </div>
    </a>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Listing Properties")}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, stream(socket, :properties, list_properties())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    property = Properties.get_property!(id)
    {:ok, _} = Properties.delete_property(property)

    {:noreply, stream_delete(socket, :properties, property)}
  end

  defp list_properties() do
    Properties.list_properties()
  end

  defp porperty_status(_property) do
    Enum.random(["Occupied", "Vacant"])
  end

  defp property_category(%Property{type: :house}), do: "House"
  defp property_category(%Property{rooms: 1}), do: "Studio"
  defp property_category(%Property{rooms: rooms}), do: "#{rooms} rooms"

  defp status_options() do
    [
      {"All", "all"},
      {"Occupied", "occupied"},
      {"Vacant", "vacant"}
    ]
  end

  defp sort_options() do
    [
      {"Newest", "newest"},
      {"Oldest", "oldest"},
      {"Area: Low to High", "area_asc"},
      {"Area: High to Low", "area_desc"}
    ]
  end
end
