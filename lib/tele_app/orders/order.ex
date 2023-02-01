defmodule TeleApp.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :products_price, :decimal
    field :user_uuid, Ecto.UUID

    has_many :order_items, TeleApp.Orders.OrderItem 
    has_many :products, through: [:order_items, :product] 

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_uuid, :products_price])
    |> validate_required([:user_uuid, :products_price])
  end
end
