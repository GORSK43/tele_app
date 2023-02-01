defmodule TeleApp.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :title, :string
      add :title_short, :string
      add :description, :string

      timestamps()
    end
  end
end
