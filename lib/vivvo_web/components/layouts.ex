defmodule VivvoWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use VivvoWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="min-h-screen h-screen flex bg-base-200 text-base-content">
      <.sidebar current_scope={@current_scope} />

      <div class="grow flex flex-col">
        <.navbar />

        <.flash_group flash={@flash} />

        <main class="grow px-15 pt-3 pb-6 overflow-y-scroll rounded-xl">
          {render_slot(@inner_block)}
        </main>
      </div>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end

  def sidebar(assigns) do
    ~H"""
    <aside id="sidebar">
      <div class="sidebar-header">
        <h1 class="sidebar-logo text-2xl font-bold text-primary ml-4">Vivvo</h1>
        <.button
          class="btn btn-ghost sidebar-toggle"
          phx-click={JS.toggle_class("open-sidebar", to: "#sidebar")}
        >
          <.icon name="hero-bars-3" class="size-6" />
        </.button>
      </div>

      <div class="sidebar-content">
        <nav class="space-y-2">
          <.link
            class="sidebar-link"
            patch={~p"/"}
          >
            <.icon name="hero-chart-pie" class="size-6" />
            <span class="sidebar-label">Dashboard</span>
          </.link>
          <.link
            class="sidebar-link active"
            patch={~p"/properties"}
          >
            <.icon name="hero-building-office-2" class="size-6" />
            <span class="sidebar-label">Properties</span>
          </.link>
          <.link
            class="sidebar-link"
            patch={~p"/contracts"}
          >
            <.icon name="hero-document-currency-dollar" class="size-6" />
            <span class="sidebar-label">Contracts</span>
          </.link>
        </nav>
      </div>
    </aside>
    """
  end

  def navbar(assigns) do
    ~H"""
    <header class="flex items-center justify-end px-6 py-4">
      <div class="flex items-center space-x-3">
        <span>Juan (Owner)</span>
        <div class="avatar avatar-placeholder">
          <div class="w-10 rounded-full bg-primary text-primary-content">
            J
          </div>
        </div>
      </div>
    </header>
    """
  end
end
