defmodule FawkesWeb.Router do
  use FawkesWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug FawkesWeb.JWTAuthPlug
  end

  scope "/api/auth", FawkesWeb do
    pipe_through [:api]
    # get("/login", AuthController, :get)
    post("/login", AuthController, :create)
    # delete("/login", AuthController, :delete)
  end

  scope "/api", FawkesWeb do
    pipe_through [:api, :auth]
    get "/ping", RoomController, :ping

    # rooms
    post "/rooms/create", RoomController, :create
    get "/rooms", RoomController, :list
    get "/rooms/:id/chat", MessageController, :get

    # users
    post "/user/register", UserController, :create

    # auth
    get "/auth", AuthController, :get
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: FawkesWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
