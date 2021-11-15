# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Piscine.Repo.insert!(%Piscine.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Piscine.Teams

Teams.create_team(%{name: "Dev"})

Teams.create_team(%{name: "RH"})

Teams.create_team(%{name: "commercial"})

# Users.create_user(
#  %{username: "user", role: 0, email: "user@email.com", team: 1}
# )
#
# Users.create_user(
#  %{username: "manager", role: 1, email: "manager@email.com", team: 2}
# )
#
# Repo.insert! %Clock{
#  time: nil,
#  status: false,
#  user_id: 1
# }
#
# Repo.insert! %Clock{
#  time: nil,
#  status: false,
#  user_id: 2
# }
#
# Repo.insert! %Clock{
#  time: nil,
#  status: false,
#  user_id: 3
# }
#
# Workingtimes.create_workingtime(
#  %{start: "2021-10-25 08:17:29", end: "2021-10-25 20:17:29", user_id: 1}
# )
#
# Workingtimes.create_workingtime(
#  %{start: "2021-10-25 09:17:29", end: "2021-10-25 16:17:29", user_id: 2}
# )
#
# Workingtimes.create_workingtime(
#  %{start: "2021-10-25 08:17:29", end: "2021-10-25 19:17:29", user_id: 3}
# )
#
