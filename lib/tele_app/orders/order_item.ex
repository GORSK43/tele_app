defmodule TeleApp.Orders.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_items" do
    field :price, :decimal
    field :qty, :integer

    belongs_to :product, TeleApp.Catalog.Product 
    belongs_to :order, TeleApp.Orders.Order 

    timestamps()
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:price, :qty])
    |> validate_required([:price, :qty])
  end
end
