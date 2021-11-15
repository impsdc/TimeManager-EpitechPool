defmodule Piscine.Repo do
  use Ecto.Repo,
    otp_app: :piscine,
    adapter: Ecto.Adapters.Postgres
end
