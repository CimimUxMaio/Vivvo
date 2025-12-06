defmodule VivvoWeb.PageController do
  use VivvoWeb, :controller

  def home(conn, _params) do
    conn
    |> assign(
      navbar: %{
        title: "Welcome to Vivvo!",
        action: %{
          name: "Get Started",
          path: ~p"/"
        }
      }
    )
    |> render(:home)
  end
end
