defmodule PiscineWeb.ClockController do
  use PiscineWeb, :controller

  alias Piscine.Clocks
  alias Piscine.Clocks.Clock
  alias PisicneWeb.AccessId
  alias Piscine.Users

  action_fallback(PiscineWeb.FallbackController)

  def index(conn, _params) do
    if(conn.role == 2) do
      clocks = Clocks.list_clocks()
      render(conn, "index.json", clocks: clocks)
    end

    if(conn.role == 1) do
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Unauthorized"})
      |> halt
    end

    if(conn.role == 0) do
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Unauthorized"})
      |> halt
    end
  end

  def show(conn, %{"id" => id}) do
    if(conn.role == 1) do
      query = Clocks.get_clock_by_user(id)

      if(query != nil) do
        user = Users.get_user(id)
        IO.inspect(user)
        manager = Users.get_user!(conn.userId)

        if(manager.team == user.team) do
          render(conn, "index.json", clocks: query)
        else
          conn
          |> put_status(:unauthorized)
          |> Phoenix.Controller.json(%{error: "Unauthorized"})
          |> halt
        end
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "Clock does not exits"})
        |> halt
      end
    end

    if(conn.role == 2) do
      query = Clocks.get_clock_by_user(id)

      if(query != nil) do
        render(conn, "index.json", clocks: query)
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "Clock does not exits"})
        |> halt
      end
    end

    if(conn.role == 0) do
      AccessId.checking(conn, %{:tokenId => conn.userId, :userId => id})
      query = Clocks.get_clock_by_user(id)

      if(query != nil) do
        render(conn, "index.json", clocks: query)
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "Clock does not exits"})
        |> halt
      end
    end
  end

  def update(conn, %{"id" => id, "time" => time, "status" => status}) do
    clock = Clocks.get_clock(id)
    IO.puts("&&&&&&&&&")

    if(clock != nil) do
      if(clock.user_id == conn.userId) do
        with {:ok, %Clock{} = clock} <-
               Clocks.update_clock(clock, %{"time" => time, "status" => status}) do
          render(conn, "show.json", clock: clock)
        end
      else
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{error: "Unauthorized"})
        |> halt
      end
    else
      conn
      |> put_status(:not_found)
      |> put_view(PiscineWeb.ErrorView)
      |> render(:"404")
    end
  end
end
