defmodule Piscine.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def up do
    create table(:clocks) do
      add :time, :naive_datetime
      add :status, :boolean, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()

    end
    create unique_index(:clocks, [:user_id])
  end

  def down do
    drop_if_exists table("clocks")
  end
end
