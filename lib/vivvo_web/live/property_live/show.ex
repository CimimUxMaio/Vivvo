defmodule VivvoWeb.PropertyLive.Show do
  use VivvoWeb, :live_view

  import VivvoWeb.PropertyLive.Helpers

  alias Vivvo.Properties

  alias VivvoWeb.PropertyLive.ContractForm
  alias VivvoWeb.PropertyLive.Form

  @impl true
  def render(assigns) do
    ~H"""
    <main class="grid grid-cols-2 gap-6">
      <section class="col-span-full w-full flex items-center justify-end gap-1">
        <.button class="btn btn-primary" onclick="edit_property_modal.showModal();">
          Edit Property
        </.button>
      </section>

      <section class="col-span-full card">
        <div class="card-body p-8 flex flex-row items-center justify-between">
          <div>
            <h2 class="card-title font-bold text-2xl mb-2">{@property.address}</h2>
            <p class="text-lg">{property_summary(@property)}</p>
          </div>

          <.status_badge property={@property} class="badge-xl" />
        </div>
      </section>

      <section class="card">
        <div class="card-body p-8 text-lg">
          <h3 class="card-title text-xl font-semibold mb-4">Contract</h3>

          <div class="grow flex flex-col gap-6">
            <div
              :if={@property.contract}
              class="grow space-y-2 text-base-content/70"
            >
              <% contract = @property.contract %>

              <div class="flex justify-between">
                <p>Tenant</p>
                <p class="text-right font-medium">{contract.tenant.name}</p>
              </div>

              <div class="flex justify-between">
                <p>Period</p>
                <p class="text-right font-medium">{format_contract_period(@property.contract)}</p>
              </div>

              <div class="flex justify-between">
                <p>Current Rent</p>
                <p class="text-right font-medium">$ {format_currency(contract.monthly_rent)}</p>
              </div>
            </div>

            <div
              :if={is_nil(@property.contract)}
              class="grow text-base-content/70 flex items-center justify-center"
            >
              <span>No active contract for this property.</span>
            </div>

            <.button
              :if={@property.contract}
              class="btn btn-primary btn-soft btn-lg"
              onclick="contract_form_modal.showModal();"
            >
              Update Contract
            </.button>

            <.button
              :if={is_nil(@property.contract)}
              class="btn btn-primary btn-soft btn-lg"
              onclick="contract_form_modal.showModal();"
            >
              New Contract
            </.button>
          </div>
        </div>
      </section>

      <section class="card">
        <div class="card-body p-8 text-lg">
          <h3 class="card-title text-xl font-semibold mb-4">Payment Status</h3>

          <div class="grow flex flex-col gap-6">
            <div class="grow text-base-content/70 flex items-center justify-between gap-4">
              <div class="flex flex-col gap-1">
                <p class="text-sm">Last Receipt</p>
                <p class="font-medium">Paid on Feb 3, 2025</p>
              </div>

              <span class="badge badge-success badge-soft badge-lg">Confirmed</span>
            </div>

            <div class="grid grid-cols-2 gap-3">
              <.button class="btn btn-secondary btn-soft btn-lg">Upload Receipt</.button>
              <.button class="btn btn-secondary btn-outline btn-lg">View Payment History</.button>
            </div>
          </div>
        </div>
      </section>

      <section class="col-span-full card">
        <div class="card-body p-8">
          <h3 class="card-title text-xl font-semibold mb-4">Pending Receipts</h3>

          <div class="box p-5 rounded-box bg-warning/5 text-base-content/70 flex items-center justify-between gap-4">
            <div>
              <span class="text-lg font-medium">February 2025 Receipt</span>
              <p class="text-sm">Uploaded by tenant 1h ago</p>
            </div>

            <.button class="btn btn-warning">Review</.button>
          </div>
        </div>
      </section>

      <section class="col-span-full card">
        <div class="card-body p-8">
          <h3 class="card-title text-xl font-semibold mb-4">Rent Value Over Time</h3>
          <div class="box p-5 rounded-box bg-base-200 text-base-content/70 flex items-center justify-center h-64">
            [Chart Placeholder]
          </div>
        </div>
      </section>

      <.modal id="contract_form_modal">
        <.live_component
          id="contract_form"
          modal="contract_form_modal"
          module={ContractForm}
          property={@property}
        />
      </.modal>

      <.modal id="edit_property_modal">
        <.live_component
          id="edit_property_form"
          modal="edit_property_modal"
          module={Form}
          property={@property}
        />
      </.modal>
    </main>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    property = Properties.get_property!(id)

    {:ok,
     socket
     |> assign(:page_title, "Property - #{property.address}")
     |> assign(:property, property)}
  end

  @impl true
  def handle_info({:property_updated, property}, socket) do
    {:noreply, assign(socket, :property, property)}
  end

  @impl true
  def handle_info({:contract_created_or_updated, _contract}, socket) do
    {:noreply, update(socket, :property, &Properties.get_property!(&1.id))}
  end

  defp format_contract_period(contract) do
    Calendar.strftime(contract.from, "%b %Y") <>
      " → " <>
      ((contract.to && Calendar.strftime(contract.to, "%b %Y")) || "Future")
  end
end
