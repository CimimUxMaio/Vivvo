defmodule VivvoWeb.PropertyLive.ContractForm do
  use VivvoWeb, :live_component

  alias Vivvo.Contracts
  alias Vivvo.Contracts.Contract

  alias Vivvo.Properties

  alias Vivvo.Tenants

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
          <span class="label mb-1">Rent</span>

          <label class="input w-full">
            <span class="label">$</span>
            <.input
              field={@form[:monthly_rent]}
              type="number"
              placeholder="123.456,78"
              step="0.01"
              min="0"
            />
          </label>

          <.error field={@form[:monthly_rent]} />
        </div>

        <div class="flex flex-col">
          <span class="label mb-1">From</span>
          <.input
            field={@form[:from]}
            type="date"
            class="input"
          />
          <.error field={@form[:from]} />
        </div>

        <div class="flex flex-col">
          <span class="label mb-1">To</span>
          <.input
            field={@form[:to]}
            type="date"
            class="input"
          />
          <.error field={@form[:to]} />
        </div>

        <div class="col-span-full flex flex-col">
          <span class="label mb-1">Payment Day</span>
          <.input
            field={@form[:payment_day]}
            type="number"
            class="input"
            placeholder="1"
            min="0"
            step="1"
          />
          <.error field={@form[:payment_day]} />
        </div>

        <div class="col-span-full flex flex-col">
          <span class="label mb-1">Tenant</span>
          <.input
            field={@form[:tenant_id]}
            type="select"
            prompt="Select tenant"
            class="select"
            options={tenant_options()}
          />
          <.error field={@form[:tenant_id]} />
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
    property = Map.get(assigns, :property)
    contract = (property && property.contract) || %Contract{}
    changeset = Contracts.change_contract(contract, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:contract, contract)
     |> assign(:action, if(contract.id, do: :edit, else: :new))
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"contract" => contract_params}, socket) do
    changeset = Contracts.change_contract(socket.assigns.contract, contract_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"contract" => contract_params}, socket) do
    save_contract(socket, socket.assigns.action, contract_params)
  end

  defp save_contract(socket, :edit, contract_params) do
    case Contracts.update_contract(socket.assigns.contract, contract_params) do
      {:ok, contract} ->
        {:noreply,
         socket
         |> put_flash(:info, "Contract updated successfully")
         |> dispatch_action_event(contract)
         |> close_modal()}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_contract(socket, :new, contract_params) do
    case Properties.create_contract(socket.assigns.property, contract_params) do
      {:ok, property} ->
        {:noreply,
         socket
         |> put_flash(:info, "Contract created successfully")
         |> dispatch_action_event(property.contract)
         |> close_modal()}

      {:error, %Ecto.Changeset{} = changeset} ->
        contract_changeset = Ecto.Changeset.get_change(changeset, :contract)
        {:noreply, assign(socket, form: to_form(contract_changeset))}
    end
  end

  defp close_modal(socket) do
    push_event(socket, "close-modal", %{id: socket.assigns.modal})
  end

  defp dispatch_action_event(socket, contract) do
    send(self(), {:contract_created_or_updated, contract})
    socket
  end

  defp tenant_options do
    Tenants.list_tenants()
    |> Enum.map(&{&1.name, &1.id})
  end
end
