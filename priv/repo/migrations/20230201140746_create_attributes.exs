defmodule TeleApp.Repo.Migrations.CreateAttributes do
  use Ecto.Migration

  def change do
    create table(:attributes) do
      add :name, :string
      add :content, :string
      add :product_id, references(:products, on_delete: :nothing)

    end

    create index(:attributes, [:product_id])
  end
end
