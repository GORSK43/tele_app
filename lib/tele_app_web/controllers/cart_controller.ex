defmodule TeleAppWeb.CartController do 
  use TeleAppWeb, :controller 

  def show(conn, _) do 
    render(conn, :show, changeset: TeleApp.ShoppingCart.change_cart(conn.assigns.cart)) 
  end

  def update(conn, %{"cart" => cart_params}) do
    case TeleApp.ShoppingCart.update_cart(conn.assigns.cart, cart_params) do
      {:ok, _cart} ->
        put_flash(conn, :success, "Успешное обновление")
        redirect(conn, to: ~p"/cart")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "При обновлении корзины произошла ошибка")
        |> redirect(to: ~p"/cart")
    end
  end

end
