defmodule VivvoWeb.PropertyLive.Form do
  use VivvoWeb, :live_component

  alias Vivvo.Properties
  alias Vivvo.Properties.Property

  alias Ecto.Enum, as: EctoEnum

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id}>
      <.form
        for={@form}
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
        class="grid grid-cols-2 gap-4"
      >
        <div class="col-span-full flex flex-col">
          <span class="label mb-1">Address</span>
          <.input
            field={@form[:address]}
            type="text"
            placeholder="Street, number, city"
            class="input"
          />
          <.error field={@form[:address]} />
        </div>

        <div class="flex flex-col">
          <span class="label mb-1">Rooms</span>
          <.input
            field={@form[:rooms]}
            type="number"
            placeholder="3"
            class="input"
          />
          <.error field={@form[:rooms]} />
        </div>

        <div class="flex flex-col">
          <span class="label mb-1">Area (m²)</span>
          <.input
            field={@form[:area]}
            type="number"
            placeholder="45"
            class="input"
            min="1"
          />
          <.error field={@form[:area]} />
        </div>

        <div class="col-span-full flex flex-col">
          <span class="label mb-1">Type of Property</span>
          <.input
            field={@form[:type]}
            type="select"
            prompt="Select type"
            class="select"
            options={property_type_options()}
          />
          <.error field={@form[:type]} />
        </div>

        <div class="mt-4 col-span-full flex items-center justify-center">
          <.button
            phx-disable-with="Saving..."
            class="btn btn-secondary w-1/2"
          >
            Save
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    property = Map.get(assigns, :property, %Property{})
    changeset = Properties.change_property(property)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:property, property)
     |> assign(:action, if(property.id, do: :edit, else: :new))
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"property" => property_params}, socket) do
    changeset = Properties.change_property(socket.assigns.property, property_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"property" => property_params}, socket) do
    save_property(socket, socket.assigns.action, property_params)
  end

  defp save_property(socket, :edit, property_params) do
    case Properties.update_property(socket.assigns.property, property_params) do
      {:ok, property} ->
        {:noreply,
         socket
         |> put_flash(:info, "Property updated successfully")
         |> dispatch_action_event(property)
         |> close_modal()}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_property(socket, :new, property_params) do
    case Properties.create_property(property_params) do
      {:ok, property} ->
        {:noreply,
         socket
         |> put_flash(:info, "Property created successfully")
         |> dispatch_action_event(property)
         |> close_modal()}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp close_modal(socket) do
    push_event(socket, "close-modal", %{id: socket.assigns.modal})
    # Reset form
    |> assign(:form, to_form(Properties.change_property(%Property{})))
  end

  defp dispatch_action_event(socket, property) do
    event =
      case socket.assigns.action do
        :new -> :property_created
        :edit -> :property_updated
      end

    send(self(), {event, property})

    socket
  end

  defp property_type_options do
    EctoEnum.values(Property, :type)
    |> Enum.map(fn type ->
      {Gettext.gettext(VivvoWeb.Gettext, format_type(type)), type}
    end)
  end

  defp format_type(:house), do: "Home"
  defp format_type(:apartment), do: "Apartment"
end
