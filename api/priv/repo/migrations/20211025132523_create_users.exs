defmodule Piscine.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add(:username, :string, size: 40, null: false)
      add(:email, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:role, :integer, null: true, default: 0)
      add(:team, :integer, null: true)
      add(:chartType, :string, null: true)
      add(:colorChart, :string, null: true)
      add(:firstTime, :boolean, default: true)

      timestamps()
    end

    create(unique_index(:users, :email))
    create(unique_index(:users, :username))
  end

  def down do
    drop_if_exists(table("users"))
  end
end
