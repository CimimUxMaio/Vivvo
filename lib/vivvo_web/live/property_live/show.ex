# defmodule VivvoWeb.PropertyLive.Show do
#   use VivvoWeb, :live_view

#   alias Vivvo.Properties

#   @impl true
#   def render(assigns) do
#     ~H"""
#     <Layouts.app flash={@flash}>
#       <.header>
#         Property {@property.id}
#         <:subtitle>This is a property record from your database.</:subtitle>
#         <:actions>
#           <.button navigate={~p"/properties"}>
#             <.icon name="hero-arrow-left" />
#           </.button>
#           <.button variant="primary" navigate={~p"/properties/#{@property}/edit?return_to=show"}>
#             <.icon name="hero-pencil-square" /> Edit property
#           </.button>
#         </:actions>
#       </.header>

#       <.list>
#         <:item title="Address">{@property.address}</:item>
#         <:item title="Area">{@property.area}</:item>
#         <:item title="Rooms">{@property.rooms}</:item>
#         <:item title="Type">{@property.type}</:item>
#       </.list>
#     </Layouts.app>
#     """
#   end

#   @impl true
#   def mount(%{"id" => id}, _session, socket) do
#     {:ok,
#      socket
#      |> assign(:page_title, "Show Property")
#      |> assign(:property, Properties.get_property!(id))}
#   end
# end
