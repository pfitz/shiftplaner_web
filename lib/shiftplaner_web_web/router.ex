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
    get "/availability/:person_id/events", AvailabilityController, :index_events
    get "/availability/:id/:event_id/edit", AvailabilityController, :edit
    get "/availability/:id/", AvailabilityController, :show
    patch "/availability/:id/:event_id", AvailabilityController, :update
    put "/availability/:id/:event_id", AvailabilityController, :update
    post "/availability/:id/:event_id", AvailabilityController, :update
    resources "/persons", PersonController

    get "/dispositon", DispositionController, :event_index
    get "/disposition/:event_id", DispositionController, :weekend_index
    get "/disposition/:event_id/:weekend_id", DispositionController, :day_index
    get "/disposition/:event_id/:weekend_id/:day_id", DispositionController, :shift_index
    get "/disposition/:event_id/:weekend_id/:day_id/:shift_id", DispositionController, :edit
    post "/disposition/:event_id/:weekend_id/:day_id/:shift_id", DispositionController, :update

  end
  # Other scopes may use custom stacks.
  # scope "/api", ShiftplanerWebWeb do
  #   pipe_through :api
  # end
end
