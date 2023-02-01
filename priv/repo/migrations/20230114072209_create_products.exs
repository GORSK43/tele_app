defmodule TeleApp.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string, null: false
      add :name_short, :string
      add :article, :string
      add :visible, :boolean, default: false, null: false
      add :price, :decimal, precision: 15, scale: 6, null: false
      add :qty, :integer, null: false, default: 0
      add :description, :string
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:products, [:article])
    create unique_index(:products, [:name_short])
    create unique_index(:products, [:name])
    create index(:products, [:category_id])
  end
end
