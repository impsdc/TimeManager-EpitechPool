defmodule PiscineWeb.WorkingtimeController do
  use PiscineWeb, :controller

  alias Piscine.Workingtimes
  alias Piscine.Workingtimes.Workingtime
  alias Piscine.Users
  alias PisicneWeb.AccessId

  action_fallback(PiscineWeb.FallbackController)

  def index(conn, params) do
    if(conn.role == 2) do
      workingtimes = Workingtimes.list_workingtimes()
      render(conn, "index.json", workingtimes: workingtimes)
    else
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Unauthorized"})
      |> halt
    end
  end

  def create(conn, %{"start" => start, "end" => ending, "user_id" => id}) do
    if(conn.role == 2) do
      user = Users.get_user(id)

      if(user != nil) do
        params = %{"start" => start, "end" => ending, "id" => id}
        existingWorkingtimes = Workingtimes.get_from_working_time(params)
        IO.inspect(existingWorkingtimes)

        if(existingWorkingtimes == []) do
          with {:ok, %Workingtime{} = workingtime} <-
                 Workingtimes.create_workingtime(%{
                   "start" => start,
                   "end" => ending,
                   "user_id" => id
                 }) do
            conn
            |> put_status(:created)
            |> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
            |> render("show.json", workingtime: workingtime)
          end
        else
          conn
          |> put_status(:unauthorized)
          |> Phoenix.Controller.json(%{error: "There is already an workingtime at this timestamp"})
          |> halt
        end
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "User not found"})
        |> halt
      end
    end

    if(conn.role == 1) do
      user = Users.get_user(id)

      if(user != nil) do
        userToken = Users.get_user!(conn.userId)

        if(userToken.team == user.team) do
          if(user.role == 2) do
            conn
            |> put_status(:unauthorized)
            |> Phoenix.Controller.json(%{error: "Unauthorized"})
            |> halt
          else
            params = %{"start" => start, "end" => ending, "id" => id}
            existingWorkingtimes = Workingtimes.get_from_working_time(params)
            IO.inspect(existingWorkingtimes)

            if(existingWorkingtimes == []) do
              with {:ok, %Workingtime{} = workingtime} <-
                     Workingtimes.create_workingtime(%{
                       "start" => start,
                       "end" => ending,
                       "user_id" => id
                     }) do
                conn
                |> put_status(:created)
                |> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
                |> render("show.json", workingtime: workingtime)
              end
            else
              conn
              |> put_status(:unauthorized)
              |> Phoenix.Controller.json(%{
                error: "There is already an workingtime at this timestamp"
              })
              |> halt
            end
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
        |> Phoenix.Controller.json(%{error: "User not found"})
        |> halt
      end
    end

    if(conn.role == 0) do
      AccessId.checking(conn, %{:tokenId => conn.userId, :userId => id})
      user = Users.get_user(id)

      if(user != nil) do
        params = %{"start" => start, "end" => ending, "id" => id}
        existingWorkingtimes = Workingtimes.get_from_working_time(params)
        IO.inspect(existingWorkingtimes)

        if(existingWorkingtimes == []) do
          with {:ok, %Workingtime{} = workingtime} <-
                 Workingtimes.create_workingtime(%{
                   "start" => start,
                   "end" => ending,
                   "user_id" => id
                 }) do
            conn
            |> put_status(:created)
            |> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
            |> render("show.json", workingtime: workingtime)
          end
        else
          conn
          |> put_status(:unauthorized)
          |> Phoenix.Controller.json(%{error: "There is already an workingtime at this timestamp"})
          |> halt
        end
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "User not found"})
        |> halt
      end
    end
  end

  def show(conn, params) do
    if(conn.role == 2) do
      if(params["start"] != nil && params["end"] != nil) do
        workingtimes = Workingtimes.get_from_working_time(params)
        render(conn, "index.json", workingtimes: workingtimes)
      else
        workingtimes = Workingtimes.get_workingtime_by_user(params["id"])

        if(workingtimes != nil) do
          render(conn, "index.json", workingtimes: workingtimes)
        else
          conn
          |> put_status(:not_found)
          |> Phoenix.Controller.json(%{error: "User not found"})
          |> halt
        end
      end
    end

    if(conn.role == 1) do
      user = Users.get_user(params["id"])

      if(user != nil) do
        userToken = Users.get_user!(conn.userId)

        if(userToken.team == user.team) do
          if(user.role == 2) do
            conn
            |> put_status(:unauthorized)
            |> Phoenix.Controller.json(%{error: "Unauthorized"})
            |> halt
          else
            if(params["start"] != nil && params["end"] != nil) do
              workingtimes = Workingtimes.get_from_working_time(params)
              render(conn, "index.json", workingtimes: workingtimes)
            else
              workingtimes = Workingtimes.get_workingtime_by_user(params["id"])

              if(workingtimes != nil) do
                render(conn, "index.json", workingtimes: workingtimes)
              else
                conn
                |> put_status(:not_found)
                |> Phoenix.Controller.json(%{error: "User not found"})
                |> halt
              end
            end
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
        |> Phoenix.Controller.json(%{error: "User not found"})
        |> halt
      end
    end

    if(conn.role == 0) do
      AccessId.checking(conn, %{:tokenId => conn.userId, :userId => params["id"]})

      if(params["start"] != nil && params["end"] != nil) do
        workingtimes = Workingtimes.get_from_working_time(params)
        render(conn, "index.json", workingtimes: workingtimes)
      else
        workingtimes = Workingtimes.get_workingtime_by_user(params["id"])

        if(workingtimes != nil) do
          render(conn, "index.json", workingtimes: workingtimes)
        else
          conn
          |> put_status(:not_found)
          |> Phoenix.Controller.json(%{error: "User not found"})
          |> halt
        end
      end
    end
  end

  def update(conn, %{"id" => id, "start" => start, "end" => ending, "user_id" => user_id}) do
    workingtime = Workingtimes.get_workingtime(id)

    if(conn.role == 2) do
      if(workingtime != nil) do
        user = Users.get_user(user_id)

        if(user != nil) do
          with {:ok, %Workingtime{} = workingtime} <-
                 Workingtimes.update_workingtime(workingtime, %{
                   "start" => start,
                   "end" => ending,
                   "user_id" => user_id
                 }) do
            render(conn, "show.json", workingtime: workingtime)
          end
        else
          conn
          |> put_status(:not_found)
          |> Phoenix.Controller.json(%{error: "Workingtime not found"})
          |> halt
        end
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "User not found"})
        |> halt
      end
    end

    if(conn.role == 1) do
      user = Users.get_user(id)
      IO.inspect(workingtime.user_id)
      old_user = Users.get_user!(workingtime.user_id)
      IO.inspect(old_user)

      if(old_user.role == 2) do
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{error: "Unauthorized"})
        |> halt
      end

      if(user != nil) do
        userToken = Users.get_user!(conn.userId)

        if(userToken.team == user.team) do
          if(user.role == 2) do
            conn
            |> put_status(:unauthorized)
            |> Phoenix.Controller.json(%{error: "Unauthorized"})
            |> halt
          else
            if(workingtime != nil) do
              user = Users.get_user(user_id)

              if(user != nil) do
                with {:ok, %Workingtime{} = workingtime} <-
                       Workingtimes.update_workingtime(workingtime, %{
                         "start" => start,
                         "end" => ending,
                         "user_id" => user_id
                       }) do
                  render(conn, "show.json", workingtime: workingtime)
                end
              else
                conn
                |> put_status(:not_found)
                |> Phoenix.Controller.json(%{error: "Workingtime not found"})
                |> halt
              end
            else
              conn
              |> put_status(:not_found)
              |> Phoenix.Controller.json(%{error: "User not found"})
              |> halt
            end
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
        |> Phoenix.Controller.json(%{error: "User not found"})
        |> halt
      end
    end

    if(conn.role == 0) do
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Unauthorized"})
      |> halt
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Workingtimes.get_workingtime(id)

    if(workingtime == nil) do
      conn
      |> put_status(:not_found)
      |> Phoenix.Controller.json(%{error: "Not found"})
      |> halt
    end

    if(conn.role >= 1) do
      user = Users.get_user(workingtime.user_id)

      if(user.role == 2 && conn.role <= 1) do
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{error: "Unauthorized"})
        |> halt
      end

      if(workingtime != nil) do
        with {:ok, %Workingtime{}} <- Workingtimes.delete_workingtime(workingtime) do
          conn
          |> Plug.Conn.send_resp(200, [])
          |> Plug.Conn.halt()
        end
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "Workingtime not found"})
        |> halt
      end
    end

    if(conn.role == 0) do
      IO.inspect(workingtime)
      AccessId.checking(conn, %{:tokenId => conn.userId, :userId => workingtime.user_id})
      workingtime = Workingtimes.get_workingtime(id)

      if(workingtime != nil) do
        with {:ok, %Workingtime{}} <- Workingtimes.delete_workingtime(workingtime) do
          conn
          |> Plug.Conn.send_resp(200, [])
          |> Plug.Conn.halt()
        end
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "Workingtime not found"})
        |> halt
      end
    end
  end
end
