defmodule TeleApp.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TeleApp.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        products_price: "120.5",
        user_uuid: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> TeleApp.Orders.create_order()

    order
  end

  @doc """
  Generate a order_item.
  """
  def order_item_fixture(attrs \\ %{}) do
    {:ok, order_item} =
      attrs
      |> Enum.into(%{
        price: "120.5",
        qty: 42
      })
      |> TeleApp.Orders.create_order_item()

    order_item
  end
end
