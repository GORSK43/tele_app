defmodule TeleApp.Catalog.Product.Attribute do
  use Ecto.Schema
  import Ecto.Changeset

  schema "attributes" do
    field :content, :string
    field :name, :string

    belongs_to :product, TeleApp.Catalog.Product
  end

  @doc false
  def changeset(attribute, attrs) do
    attribute
    |> cast(attrs, [:name, :content])
    |> validate_required([:name, :content])
  end
end
