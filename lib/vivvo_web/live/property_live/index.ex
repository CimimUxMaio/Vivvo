defmodule VivvoWeb.PropertyLive.Index do
  use VivvoWeb, :live_view

  import VivvoWeb.PropertyLive.Helpers

  alias Vivvo.Properties

  alias VivvoWeb.PropertyLive.Form

  @impl true
  def render(assigns) do
    ~H"""
    <main class="flex flex-col gap-6">
      <section class="w-full">
        <div class="flex flex-row items-center justify-between gap-3">
          <label class="input">
            <div class="label flex items-center justify-between p-2">
              <.icon name="hero-magnifying-glass" />
            </div>
            <input
              type="text"
              placeholder="Search properties..."
              class="w-1/2"
            />
          </label>

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

            <button class="btn btn-primary" onclick="new_property_modal.showModal()">
              <.icon name="hero-plus" class="size-5" /> New Property
            </button>
          </div>
        </div>
      </section>

      <section id="properties" class="w-full grid grid-cols-3 gap-5" phx-update="stream">
        <.property_card :for={{id, property} <- @streams.properties} property={property} id={id} />
      </section>
    </main>

    <.modal id="new_property_modal">
      <.live_component
        id="property_form"
        module={Form}
        modal="new_property_modal"
      />
    </.modal>
    """
  end

  def property_card(assigns) do
    category = property_category(assigns.property)
    status = property_status(assigns.property)

    assigns =
      assigns
      |> Map.put(:category, category)
      |> Map.put(:status, status)

    ~H"""
    <.link
      id={@id}
      patch={~p"/properties/#{@property}"}
      class="card"
    >
      <figure class="h-40 w-full overflow-hidden">
        <img
          src="https://www.contenedoresmaracana.com/wp-content/plugins/elementor/assets/images/placeholder.png"
          alt="Property"
          class="w-full h-full object-cover"
        />
      </figure>

      <div class="card-body space-y-1">
        <div class="flex items-center justify-between">
          <h3 class="card-title font-semibold text-lg">{@property.address}</h3>
          <.status_badge property={@property} />
        </div>

        <p class="text-sm text-base-content/70">{property_summary(@property)}</p>

        <div class="flex justify-between items-center text-sm">
          <span :if={@status == "Occupied"}>Next payment: <strong>Feb 10</strong></span>
          <span :if={@status == "Vacant"}>No active lease</span>
          <span class="text-accent font-medium">1 receipt</span>
        </div>
      </div>
    </.link>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Listing Properties")}
  end

  @impl true
  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, stream(socket, :properties, list_properties())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    property = Properties.get_property!(id)
    {:ok, _} = Properties.delete_property(property)

    {:noreply, stream_delete(socket, :properties, property)}
  end

  @impl true
  def handle_info({:property_created, property}, socket) do
    {:noreply, stream_insert(socket, :properties, property)}
  end

  defp list_properties do
    Properties.list_properties()
  end

  defp status_options do
    [
      {"All", "all"},
      {"Occupied", "occupied"},
      {"Vacant", "vacant"}
    ]
  end

  defp sort_options do
    [
      {"Newest", "newest"},
      {"Oldest", "oldest"},
      {"Area: Low to High", "area_asc"},
      {"Area: High to Low", "area_desc"}
    ]
  end
end
