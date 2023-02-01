defmodule TeleAppWeb.OrderController do
  use TeleAppWeb, :controller

  alias TeleApp.Orders

  def create(conn, _) do
    case Orders.create_order(conn.assigns.cart) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Заказ оформлен. Ждёт оплаты")
        |> redirect(to: ~p"/orders/#{order}")

      {:error, _reason} ->
        conn 
        |> put_flash(:error, "Ошибка при оформлении заказа")
        |> redirect(to: ~p"/cart") 
    end
  end

  def show(conn, %{"id" => id}) do
    order = Orders.get_order!(conn.assigns.current_uuid, id)
    render(conn, :show, order: order)
  end

end
