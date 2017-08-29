defmodule ShiftplanerWebWeb.AvailabilityController do
  @moduledoc false

  alias Shiftplaner.Event

  use ShiftplanerWebWeb, :controller

  def index(conn, _params) do
    persons = Shiftplaner.list_persons()
    render(conn, "index.html", persons: persons)
  end

  def edit(conn, %{"id" => id}) do
    person = Shiftplaner.get_person!(id)
    events = Event.list_all_active_events()
    #changeset = Shiftplaner.change_availability()

    render(conn, "edit.html", person: person, events: events)
  end

  def show(conn, %{"id" => id}) do
    person = Shiftplaner.get_person!(id)
    available_shifts = Shiftplaner.list_available_shifts_for_person(person)

    render(conn, "show.html", shifts: available_shifts, person: person)
  end

  def update(conn, %{"avl" => avl, "id" => id}) do
    selected_available_shifts =
      avl
      |> Enum.filter(fn ({_k, v}) -> v == "true" end)
      |> Map.new()
      |> Map.keys()

    Shiftplaner.update_persons_availability_for_shifts(id, selected_available_shifts)

    conn
    |> redirect(to: availability_path(conn, :index))
  end
end
