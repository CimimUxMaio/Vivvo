defmodule VivvoWeb.Helpers do
  @moduledoc false
  use Phoenix.Component

  def format_currency(%Decimal{} = amount) do
    amount
    |> Decimal.to_float()
    |> format_currency()
  end

  def format_currency(amount) when is_number(amount) do
    # Format the number as currency (e.g. 1,234.56)
    amount
    |> :erlang.float_to_binary(decimals: 2)
    |> String.split(".")
    |> case do
      [whole | fraction] ->
        formatted_whole =
          whole
          |> String.reverse()
          |> String.graphemes()
          |> Enum.chunk_every(3)
          |> Enum.map_join(",", &Enum.join/1)
          |> String.reverse()

        Enum.join([formatted_whole | fraction], ".")
    end
  end
end
