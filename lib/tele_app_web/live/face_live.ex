defmodule TeleAppWeb.FaceLive do
  use TeleAppWeb, :live_view
  alias TeleApp.{Catalog, ShoppingCart}
  @img_dir "/images/products"
  @product_img_dir Application.get_env(:tele_app, :product_img_dir)

  def mount(_params, session, socket) do
    IO.puts(" ---MOUNTED ----pid: connected?: #{connected?(socket)} --  ")
    {:ok,
     assign(socket,
       products: Catalog.list_products(),
       cart: fetch_current_cart(session),
       categories: Catalog.list_categories(),
       address: %{},
       viewed_product: nil,
       show_map: false
     )}
  end

  def handle_params(params, _uri, socket) do
    IO.puts(" ----- HANDLE PARAMs  ----")
    IO.inspect(params["category"])

    socket =
      if params["category"] in Enum.map(socket.assigns.categories, &to_string(&1.id)) do
        assign(socket, :products, Catalog.list_products_in_category(params["category"]))
      else
        if params["category"] == "",
          do: assign(socket, :products, Catalog.list_products()),
          else: socket
      end
    {:noreply, socket}
  end

  attr :address, :any, required: true

  def delivery(assigns) do
    ~H"""
    <div>
      <h2 class="text-3xl text-gray-800 mt-8">Выбор пункта выдачи / постомата</h2>
      <div phx-hook="YMap" phx-update="ignore" id="map" class="w-full" style="min-height:550px"></div>
      <div class="w-full h-36 bg-sky-100 mb-2 p-4 text-sky-800">
        <%= Map.get(@address, :pvz) %>
      </div>
    </div>
    """
  end

  attr :name, :string, required: true
  attr :price, :any, required: true
  attr :prtid, :integer, required: true
  attr :qty, :any, required: true

  def product_card(assigns) do
    ~H"""
    <div class="basis-[32%] flex justify-between p-1">
      <div class="rounded-lg border bg-white max-w-sm relative">
        <div class={"absolute right-0 top-0 #{@qty && "visible" || "invisible"}"}>
          <div class="flex space-x-2 justify-center">
            <span class="text-xs inline-block py-1.5 px-2.5 text-center align-baseline font-bold bg-blue-600 text-white rounded-full">
              <%= @qty %>
            </span>
          </div>
        </div>
        <div
          class="cursor-pointer"
          phx-click={JS.push("viewed_product", value: %{id: @prtid}) |> show_modal("prod_id")}
        >
          <img class="rounded-t-lg" src={img_path(@prtid)} alt="" />
        </div>
        <div class="p-3">
          <h5 class="text-blue-800 text-sm font-medium my-0.5"><%= currency_to_str(@price) %></h5>
          <p class="text-gray-700 text-bold mb-1"><%= @name %></p>
          <div class="flex justify-around">
            <button
              phx-click="add_product_to_cart"
              phx-value-prtid={@prtid}
              class="basis-1/4 flex-auto btn-primary text-sm"
            >
              &plus;
            </button>
            <button
              phx-click="remove_product_from_cart"
              phx-value-prtid={@prtid}
              class={"basis-1/4 flex-auto btn-light text-sm #{@qty && "visible" || "invisible"}"}
            >
              del
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :cart, ShoppingCart.Cart, required: true
  attr :address, :map, required: true
  attr :show_map, :boolean, default: false

  def cart(assigns) do
    ~H"""
    <div id="checkout" class="hidden">
      <h1 class="text-2xl">
        Корзина
          <button phx-click={show_catalog()} class="btn-primary float-right text-sm">изменить</button>
      </h1>
      <table class="table-auto border-collapse w-full">
        <tbody>
          <%= for item <- @cart.items do %>
            <tr>
              <td>
                <img src={img_path(item.product.id)} class="w-28" />
              </td>
              <td>
                <h3 class="text-xl">
                  <%= item.product.name %> &nbsp; <span class="text-cyan-700">x <%= item.qty %></span>
                </h3>
                <span class="text-sm text-gray-700"><%= item.product.article %></span>
              </td>
              <td class="text-right">
                <span class="text-lg">
                  <%= currency_to_str(ShoppingCart.total_item_price(item)) %>
                </span>
              </td>
            </tr>
          <% end %>
          <tr>
            <td>Доставка</td>
            <td><%= Map.get(@address, :pvz) %></td>
            <td class="text-right">
              <span class="text-lg">
                <%= currency_to_str(Map.get(@address, :cost, Decimal.new(0))) %>
              </span>
            </td>
          </tr>
        </tbody>
      </table>
      <p class="text-semibold text-lg py-4 text-right">
        Итого: &nbsp; <%= currency_to_str(ShoppingCart.total_cart_price(@cart)) %>
      </p>
      <button class="btn-warning" phx-click={JS.push("show_map") |> JS.add_class("hidden")}>
        Выдача заказа
      </button>
      <!-- YMap -->
      <.delivery :if={@show_map} address={@address}/>
    </div>
    """
  end

  def img_path(id),
    do:
      if(File.exists?("#{@product_img_dir}/#{id}.norm.jpg"),
        do: "#{@img_dir}/#{id}.norm.jpg",
        else: "#{@img_dir}/23.norm.jpg"
      )

  def highlite_buttons() do
    %JS{}
    |> JS.remove_class("bg-gray-400", to: "[role=button]")
    |> JS.add_class("bg-gray-400")
  end

  def show_checkout() do 
    JS.remove_class("block", to: "#explore", transition: "fade-out") 
    |> JS.add_class("hidden", to: "#explore") 
    |> JS.remove_class("hidden", to: "#checkout") 
    |> JS.add_class("block", to: "#checkout", transition: {"transition-opacity ease-in duration-500", "opacity-0", "opacity-100"})
  end

  def show_catalog() do 
    JS.remove_class("block", to: "#checkout", transition: "fade-out") 
    |> JS.add_class("hidden", to: "#checkout") 
    |> JS.remove_class("hidden", to: "#explore") 
    |> JS.add_class("block", to: "#explore", transition: {"transition-opacity ease-in duration-500", "opacity-0", "opacity-100"})
  end

  def handle_event("add_product_to_cart", %{"prtid" => prtid}, socket) do
    new_cart =
      case ShoppingCart.add_item_to_cart(socket.assigns.cart, prtid) do
        {:ok, _item} -> ShoppingCart.reload(socket.assigns.cart)
        {:error, _} -> socket.assigns.cart
      end

    # IO.inspect(new_cart.items)
    {:noreply, assign(socket, cart: new_cart)}
  end

  def handle_event("remove_product_from_cart", %{"prtid" => prtid}, socket) do
    {:ok, new_cart} = ShoppingCart.remove_item_from_cart(socket.assigns.cart, prtid)
    {:noreply, assign(socket, :cart, new_cart)}
  end

  def handle_event("viewed_product", %{"id" => id}, socket) do
    {:noreply, assign(socket, :viewed_product, Catalog.get_product!(id))}
  end

  def handle_event("pvz", %{"address" => address, "id" => id}, socket) do
    IO.puts("----PVZ----")
    cost = Decimal.new(id)
    {:noreply, assign(socket, :address, %{pvz: address, cost: cost})}
  end

  def handle_event("show_map", _, socket) do 
    {:noreply, assign(socket, :show_map, true)}
  end

  def currency_to_str(%Decimal{} = val), do: "#{Decimal.round(val, 2)} руб"

  def get_qty(cart, product_id) do
    case Enum.filter(cart.items, fn item -> item.product_id == product_id end) do
      [el] -> el.qty
      [] -> nil
    end
  end

  defp fetch_current_cart(session),
    do: TeleApp.ShoppingCart.get_cart_by_uuid(session["current_uuid"])
end
