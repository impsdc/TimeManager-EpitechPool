defmodule Piscine.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  alias Piscine.Users.User

  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :naive_datetime,  null: true, blank: true
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :user_id])
    |> validate_required([:status,])
    |> assoc_constraint(:user)
  end
end
