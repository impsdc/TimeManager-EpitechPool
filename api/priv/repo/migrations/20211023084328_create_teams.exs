defmodule Piscine.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def up do
    create table(:teams) do
      add :name, :string, null: false
      add :icon, :string, null: true

      timestamps()
    end
    create unique_index(:teams, :name)
  end

  def down do
    drop_if_exists table("teams")
  end
end
