defmodule VivvoWeb.PropertyLive.Show do
  use VivvoWeb, :live_view

  import VivvoWeb.PropertyLive.Helpers

  alias Vivvo.Properties

  @impl true
  def render(assigns) do
    ~H"""
    <main class="grid grid-cols-2 gap-6">
      <section class="col-span-full w-full flex items-center justify-end gap-1">
        <.button class="btn btn-primary">Edit Property</.button>
        <.button class="btn">Update Contract</.button>
        <.button class="btn">Upload Receipt</.button>
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
            <div class="grow space-y-2 text-base-content/70">
              <div class="flex justify-between">
                <p>Tenant</p>
                <p class="text-right font-medium">Carlos Mendoza</p>
              </div>

              <div class="flex justify-between">
                <p>Period</p>
                <p class="text-right font-medium">Jan 2023 - Jan 2027</p>
              </div>

              <div class="flex justify-between">
                <p>Current Rent</p>
                <p class="text-right font-medium">$300.000</p>
              </div>
            </div>

            <.button class="btn btn-primary btn-soft btn-lg">View Contract</.button>
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

            <.button class="btn btn-neutral btn-outline btn-lg">View Payment History</.button>
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
end
