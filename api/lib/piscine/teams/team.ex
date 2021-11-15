defmodule Piscine.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias Piscine.Users.User

  schema "teams" do
    field(:name, :string, null: false)
    field(:icon, :string, null: true)
    has_many(:users, User, on_replace: :nilify)

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :icon])
    |> unique_constraint(:name)
    |> validate_required([:name])
    |> cast_assoc(:users)
  end
end
