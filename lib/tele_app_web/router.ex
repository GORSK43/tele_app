defmodule TeleAppWeb.Router do
  use TeleAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TeleAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_uuid
    plug :fetch_current_cart
  end

  defp fetch_current_uuid(conn, _) do
    conn = 
    if uuid = get_session(conn, :current_uuid) do
      assign(conn, :current_uuid, uuid)
    else
      new_uuid = Ecto.UUID.generate()

      conn
      |> put_session(:current_uuid, new_uuid)
      |> assign(:current_uuid, new_uuid)
    end
    IO.puts(uuid)
    conn
  end

  defp fetch_current_cart(conn, _) do
    if cart = TeleApp.ShoppingCart.get_cart_by_uuid(conn.assigns.current_uuid) do
      assign(conn, :cart, cart)
    else
      {:ok, new_cart} = TeleApp.ShoppingCart.create_cart_by_uuid(conn.assigns.current_uuid)
      assign(conn, :cart, new_cart)
    end
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TeleAppWeb do
    pipe_through :browser

    get "/", PageController, :home
    resources "/categories", CategoryController
    resources "/products", ProductController
    resources "/cart_items", CartItemController, only: [:create, :delete]
    resources "/orders", OrderController, only: [:create, :show] 

    get "/cart", CartController, :show
    put "/cart", CartController, :update
  end

  live_session :shop, layout: {TeleAppWeb.Layouts, :live_app} do 
    scope "/shop", TeleAppWeb do 
      pipe_through :browser
      live "/", FaceLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", TeleAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:tele_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TeleAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
