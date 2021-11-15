defmodule Piscine.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Piscine.Clocks.Clock

  schema "users" do
    field :username, :string,  null: :false
    field :email, :string,  null: :false
    field :password_hash, :string,  null: :false
    field :role, :integer,  null: :false
    field :team, :integer, null: :false, default: 0
    field :chartType, :string, null: true
    field :colorChart, :string, null: true
    field :firstTime, :boolean, default: false
    has_one(:clocks, Clock, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :role, :team, :colorChart, :chartType, :password_hash, :firstTime])
    |> validate_required([:username, :email, :role, :password_hash])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> cast_assoc(:clocks)
    |> validate_format(:email, ~r/\S+@\S+\.\S+/)

  end
end
