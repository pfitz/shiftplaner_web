defmodule ShiftplanerWebWeb.FrontController do
  @moduledoc false
  use ShiftplanerWebWeb, :controller
  alias Shiftplaner.Event

  def index(conn, _params) do
    events = Event.load_all_active_events()

    render conn, "index.html", events: events
  end


end
