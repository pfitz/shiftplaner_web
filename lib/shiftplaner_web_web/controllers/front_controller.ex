defmodule ShiftplanerWebWeb.FrontController do
  @moduledoc false
  use ShiftplanerWebWeb, :controller
  alias Shiftplaner.Event

  def index(conn, _params) do
    events = Event.list_all_active_events()

    render conn, "index.html", events: events
  end


end
