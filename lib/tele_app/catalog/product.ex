defmodule TeleApp.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :article, :string
    field :description, :string
    field :name, :string
    field :name_short, :string
    field :price, :decimal
    field :qty, :integer
    field :visible, :boolean, default: false
#   field :category_id, :id
    belongs_to :category, TeleApp.Catalog.Category
    has_many :attributes, TeleApp.Catalog.Product.Attribute

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :name_short, :article, :visible, :price, :qty, :description, :category_id])
    |> validate_required([:name, :name_short, :article, :visible, :price, :qty, :description, :category_id])
    |> unique_constraint(:article)
    |> unique_constraint(:name_short)
    |> unique_constraint(:name)
  end
end
