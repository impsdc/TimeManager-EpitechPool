defmodule Piscine.Repo.Migrations.CreateWorkingtimes do
  use Ecto.Migration

  def up do
    create table(:workingtimes) do
      add :start, :naive_datetime, null: false
      add :end, :naive_datetime,null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:workingtimes, [:user_id])
  end

  def down do
    drop_if_exists table("workingtimes")
  end
end
  