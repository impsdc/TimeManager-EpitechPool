defmodule PisicneWeb.JwtAuthPlug do
  import Plug.Conn
  alias Pisicne.Token

  def init(opts), do: opts

  def call(conn, _opt) do
    response = Plug.Conn.fetch_cookies(conn, signed: ~w(authCookie))

    if(response.cookies != %{}) do
      token = response.cookies["authCookie"].authCookie
      validate = Token.verify_and_validate(token)

      if(elem(validate, 0) == :error) do
        if(Enum.at(elem(validate, 1), 0) == {:message, "Invalid token"}) do
          conn
          |> put_status(:unauthorized)
          |> Phoenix.Controller.json(%{error: "Token expired"})
          |> halt
        else
          conn
          |> put_status(:unauthorized)
          |> Phoenix.Controller.json(%{error: "Token corrupted"})
          |> halt
        end
      end

      conn = Map.put(conn, :userId, elem(validate, 1)["user_id"])
      conn = Map.put(conn, :role, elem(validate, 1)["role"])
      IO.puts("USER ID ")
      IO.inspect(conn.userId)
      IO.puts("ROLE")
      IO.inspect(conn.role)
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{error: "Token corrupted"})
      |> halt
    end
  end
end
