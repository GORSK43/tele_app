defmodule TeleApp.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :description, :string
    field :title, :string
    field :title_short, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title, :title_short, :description])
    |> validate_required([:title, :title_short, :description])
  end
end
