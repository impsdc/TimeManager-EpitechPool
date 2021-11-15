defmodule PiscineWeb.UserController do
  use PiscineWeb, :controller

  alias Piscine.Users
  alias Piscine.Users.User
  alias Piscine.Clocks.Clock
  alias Piscine.Teams
  alias Piscine.Repo
  alias Pisicne.Token
  alias PisicneWeb.AccessId

  action_fallback(PiscineWeb.FallbackController)

  def index(conn, params) do
    # check role
    if(conn.role == 2) do
      # check params
      if(params["email"] != nil && params["username"] != nil) do
        user = Users.get_by_email_and_username(params)

        if(user != nil) do
          render(conn, "show.json", user: user)
        else
          conn
          |> put_status(:not_found)
          |> Phoenix.Controller.json(%{error: "User does not exits"})
          |> halt
        end
      end

      users = Users.list_users()
      render(conn, "index.json", users: users)
    else
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Unauthorized"})
      |> halt
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    user = Users.get_by_email(email)
    correct_password = Bcrypt.check_pass(user, password)

    if(
      correct_password == {:error, "invalid password"} or
        correct_password == {:error, "invalid user-identifier"}
    ) do
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Wrong credentials"})
      |> halt
    else
      custom_claims = %{"user_id" => user.id, "role" => user.role}
      token = Token.generate_and_sign!(custom_claims)

      conn =
        Plug.Conn.put_resp_cookie(conn, "authCookie", %{authCookie: token},
          http_only: true,
          sign: true,
          max_age: 2_592_000,
          same_site: "none",
          secure: true
        )

      user = Map.put(user, :token, token)
      render(conn, "show_with_token.json", user: user)
    end
  end

  def get_by_team(conn, %{"id" => id}) do
    if(conn.role == 0) do
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Unauthorized"})
      |> halt
    end

    if(conn.role == 1) do
      user = Users.get_user!(conn.userId)

      if(user.team != String.to_integer(id)) do
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{error: "Unauthorized"})
        |> halt
      else
        users = Users.get_users_by_team(id)

        if(users != []) do
          render(conn, "index.json", users: users)
        else
          conn
          |> put_status(:not_found)
          |> Phoenix.Controller.json(%{error: "Team got 0 users"})
          |> halt
        end
      end
    end

    if(conn.role == 2) do
      users = Users.get_users_by_team(id)

      if(users != []) do
        render(conn, "index.json", users: users)
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "Team got 0 users"})
        |> halt
      end
    end
  end

  def register(conn, %{
        "username" => username,
        "email" => email,
        "role" => role,
        "team" => team_id
      }) do
    if(conn.role >= 1) do
      team = Teams.get_team(team_id)

      if(team != nil) do
        hashed_password = Bcrypt.add_hash(username)

        with {:ok, %User{} = user} <-
               Users.create_user(%{
                 "username" => username,
                 "email" => email,
                 "password_hash" => hashed_password.password_hash,
                 "role" => role,
                 "team" => team_id
               }) do
          # empty clock for each user created
          Repo.insert!(%Clock{
            time: nil,
            status: false,
            user_id: user.id
          })

          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.user_path(conn, :show, user))
          |> render("show.json", user: user)
        end
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "Team does not exits"})
        |> halt
      end
    else
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Unauthorized"})
      |> halt
    end
  end

  def change_password(conn, %{"id" => id, "password" => password, "newpassword" => newpassword}) do
    AccessId.checking(conn, %{:tokenId => conn.userId, :userId => id})
    user = Users.get_user(id)

    if(user != nil) do
      correct_password = Bcrypt.check_pass(user, password)

      if(correct_password != {:error, "invalid password"}) do
        hashed_password = Bcrypt.add_hash(newpassword)

        with {:ok, %User{} = user} <-
               Users.update_user(user, %{
                 "email" => user.email,
                 "username" => user.username,
                 "role" => user.role,
                 "colorChart" => user.colorChart,
                 "chartType" => user.chartType,
                 "team" => user.team,
                 "password_hash" => hashed_password.password_hash
               }) do
          render(conn, "show.json", user: user)
        end
      else
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{error: "Wrong password"})
        |> halt
      end
    else
      conn
      |> put_status(:not_found)
      |> Phoenix.Controller.json(%{error: "User does not exits"})
      |> halt
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user(id)

    if(user != nil) do
      if(conn.role == 1) do
        manager = Users.get_user!(conn.userId)

        if(manager.team == user.team) do
          render(conn, "show.json", user: user)
        else
          conn
          |> put_status(:unauthorized)
          |> Phoenix.Controller.json(%{error: "Unauthorized"})
          |> halt
        end
      end

      if(conn.role == 2) do
        render(conn, "show.json", user: user)
      end

      if(conn.role == 0) do
        AccessId.checking(conn, %{:tokenId => conn.userId, :userId => id})
        render(conn, "show.json", user: user)
      end
    else
      conn
      |> put_status(:not_found)
      |> Phoenix.Controller.json(%{error: "User does not exits"})
      |> halt
    end
  end

  def update(conn, params) do
    user = Users.get_user(params["id"])

    if(conn.role == 2) do
      if(user != nil) do
        if(params["team"] != nil) do
          team = Teams.get_team(params["team"])

          if(team != nil) do
            with {:ok, %User{} = user} <-
                   Users.update_user(user, params) do
              conn
              |> put_status(:created)
              |> put_resp_header("location", Routes.user_path(conn, :show, user))
              |> render("show.json", user: user)
            end
          else
            conn
            |> put_status(:not_found)
            |> Phoenix.Controller.json(%{error: "Team does not exits"})
            |> halt
          end
        else
          with {:ok, %User{} = user} <-
                 Users.update_user(user, params) do
            render(conn, "show.json", user: user)
          end
        end
      else
        conn
        |> put_status(:not_found)
        |> Phoenix.Controller.json(%{error: "User does not exits"})
        |> halt
      end
    end

    if(conn.role <= 1) do
      if(params["team"] == nil and params["role"] == nil) do
        AccessId.checking(conn, %{:tokenId => conn.userId, :userId => params["id"]})

        if(user != nil) do
          with {:ok, %User{} = user} <-
                 Users.update_user(user, params) do
            render(conn, "show.json", user: user)
          end
        else
          conn
          |> put_status(:not_found)
          |> Phoenix.Controller.json(%{error: "User does not exits"})
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

  def delete(conn, %{"id" => id}) do
    user = Users.get_user(id)

    if(user != nil) do
      if(conn.role == 2) do
        with {:ok, %User{}} <- Users.delete_user(user) do
          conn
          |> Plug.Conn.send_resp(200, [])
          |> Plug.Conn.halt()
        end
      end

      AccessId.checking(conn, %{:tokenId => conn.userId, :userId => id})

      with {:ok, %User{}} <- Users.delete_user(user) do
        conn
        |> Plug.Conn.send_resp(200, [])
        |> Plug.Conn.halt()
      end
    else
      conn
      |> put_status(:not_found)
      |> Phoenix.Controller.json(%{error: "User does not exits"})
      |> halt
    end
  end

  def logout(conn, _params) do
    conn = Plug.Conn.delete_resp_cookie(conn, "authCookie")

    conn
    |> put_status(:ok)
    |> Phoenix.Controller.json(%{success: "Successly logout"})
    |> halt
  end
end
