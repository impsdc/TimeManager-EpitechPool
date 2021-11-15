defmodule PisicneWeb.AccessId do
  use PiscineWeb, :controller

  def checking(conn, attrs) do
    IO.inspect(attrs)
    tokenId = attrs.tokenId

    if(is_binary(attrs.userId)) do
      paramsId = String.to_integer(attrs.userId)

      if(paramsId != tokenId) do
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{
          error: "You do not have the right to access to this ressource"
        })
        |> halt
      end
    else
      paramsId = attrs.userId

      if(paramsId != tokenId) do
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{
          error: "You do not have the right to access to this ressource"
        })
        |> halt
      end
    end

    conn
  end
end
