defmodule TeleAppWeb.CartItemController do
  use TeleAppWeb, :controller
  alias TeleApp.ShoppingCart

  def create(conn, %{"product_id" => product_id}) do
    case ShoppingCart.add_item_to_cart(conn.assigns.cart, product_id) do
      {:ok, _item} -> put_flash(conn, :info, "Добавлена в корзину 1 шт.")
      {:error, _changeset} -> put_flash(conn, :error, "Ошибка при добавлении товара")
    end

#   redirect(conn, to: ~p"/products/#{product_id}")
    redirect(conn, to: ~p"/cart") 
  end

  def delete(conn, %{"id" => id}) do 
    case ShoppingCart.remove_item_from_cart(conn.assigns.cart, id) do 
      {:ok, _cart} -> put_flash(conn, :info, "1 шт. удалена")
      {:error, _} -> put_flash(conn, :error, "Ошибка при удалении товара")
    end

    redirect(conn, to: ~p"/cart")
  end
end
