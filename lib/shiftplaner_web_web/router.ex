defmodule ShiftplanerWebWeb.Router do
  use ShiftplanerWebWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin_layout do
    plug :put_layout, {ShiftplanerWebWeb.LayoutView, :admin_layout }
  end
  scope "/", ShiftplanerWebWeb do
    pipe_through :browser # Use the default browser stack

    get "/", FrontController, :index
  end

  scope "/admin", ShiftplanerWebWeb do
    pipe_through [:browser, :admin_layout]

    get "/", AdminController, :index

    resources "/events", EventController do
      resources "/weekends", WeekendController do
        resources "/days", DayController do
          resources "/shifts", ShiftController
        end
      end
    end

    get "/availability", AvailabilityController, :index
    get "/availability/:id/edit", AvailabilityController, :edit
    get "/availability/:id", AvailabilityController, :show
    patch "/availability/:id", AvailabilityController, :update
    put "/availability/:id", AvailabilityController, :update
    post "/availability/:id", AvailabilityController, :update
    resources "/persons", PersonController
  end
  # Other scopes may use custom stacks.
  # scope "/api", ShiftplanerWebWeb do
  #   pipe_through :api
  # end
end
