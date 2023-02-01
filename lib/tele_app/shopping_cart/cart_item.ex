defmodule TeleApp.ShoppingCart.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cart_items" do
    field :price, :decimal
    field :qty, :integer
    belongs_to :product, TeleApp.Catalog.Product
    belongs_to :cart, TeleApp.ShoppingCart.Cart
    timestamps()
  end

  @doc false
  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:price, :qty])
    |> validate_required([:price, :qty])
    |> validate_number(:qty, greater_than_or_equal_to: 0, less_than: 100)
  end
end
