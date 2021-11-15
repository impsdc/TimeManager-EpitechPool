defmodule PiscineWeb.Router do
  use PiscineWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(CORSPlug)
    #   plug :protect_from_forgery
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(CORSPlug)
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(CORSPlug)
    plug(PisicneWeb.JwtAuthPlug)
    plug(:accepts, ["json"])
  end

  # connected
  scope "/api", PiscineWeb do
    pipe_through(:auth)

    resources("/teams", TeamController, except: [:new, :edit])
    resources("/users", UserController, except: [:new])
    resources("/clocks", ClockController, except: [:new, :edit])
    post("/changepassword/:id", UserController, :change_password)
    resources("/workingtimes", WorkingtimeController, except: [:new, :edit])

    resources("/workingtimes", WorkingtimeController, except: [:new, :edit])

    get("/users/team/:id", UserController, :get_by_team)
    post("/register", UserController, :register)
  end

  # public
  scope "/api", PiscineWeb do
    pipe_through(:browser)

    post("/login", UserController, :login)
    get("/logout", UserController, :logout)
    # not revelant
    get("/workingtimes/:user_id/:id/", WorkingtimeController, :get_single_workingtime_by_user)
  end
end
