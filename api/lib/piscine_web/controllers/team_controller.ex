defmodule PiscineWeb.TeamController do
  use PiscineWeb, :controller

  alias Piscine.Teams
  alias Piscine.Teams.Team
  alias Piscine.Users

  action_fallback(PiscineWeb.FallbackController)

  def index(conn, _params) do
    if(conn.role == 2) do
      teams = Teams.list_teams()
      render(conn, "index.json", teams: teams)
    else
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Unauthorized"})
      |> halt
    end
  end

  def create(conn, %{"name" => name}) do
    if(conn.user == 2) do
      with {:ok, %Team{} = team} <- Teams.create_team(%{"name" => name}) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.team_path(conn, :show, team))
        |> render("show.json", team: team)
      end
    else
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Unauthorized"})
      |> halt
    end
  end

  def show(conn, %{"id" => id}) do

    if(conn.role == 0) do
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Unauthorized"})
      |> halt
    end

    if(conn.role == 2) do
      team = Teams.get_team(id)

      if(team != nil) do
        render(conn, "show.json", team: team)
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "Team not found"})
        |> halt
      end
    end

    if(conn.role == 1) do
      user = Users.get_user(conn.userId)
      IO.inspect(user.team)
      IO.inspect(id)

      if(user.team == String.to_integer(id)) do
        team = Teams.get_team(id)

        if(team != nil) do
          render(conn, "show.json", team: team)
        else
          conn
          |> put_status(:not_found)
          |> Phoenix.Controller.json(%{error: "Team not found"})
          |> halt
        end
      else
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{error: "Unauthorized"})
        |> halt
      end
    end
  end

  def update(conn, %{"name" => name, "id" => id}) do
    if(conn.role == 2) do
      team = Teams.get_team(id)

      if(team != nil) do
        with {:ok, %Team{} = team} <- Teams.update_team(team, %{"name" => name}) do
          render(conn, "show.json", team: team)
        end
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "Team not found"})
        |> halt
      end
    else
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Unauthorized"})
      |> halt
    end
  end

  def delete(conn, %{"id" => id}) do
    if(conn.role == 2) do
      team = Teams.get_team(id)

      if(team != nil) do
        with {:ok, %Team{}} <- Teams.delete_team(team) do
          conn
          |> Plug.Conn.send_resp(200, [])
          |> Plug.Conn.halt()
        end
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "Team not found"})
        |> halt
      end
    else
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Unauthorized"})
      |> halt
    end
  end
end
