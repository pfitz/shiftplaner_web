defmodule ShiftplanerWebWeb.EventController do
  alias Shiftplaner.Event
  use ShiftplanerWebWeb, :controller

  def index(conn, _params) do
    events = Shiftplaner.list_all_events()
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Shiftplaner.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    case Shiftplaner.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    {:ok, event} = Shiftplaner.get_event(id)
    render(conn, "show.html", event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = Shiftplaner.get_event!(id)
    changeset = Shiftplaner.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Shiftplaner.get_event!(id)

    case Shiftplaner.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    {:ok, _event} =
      id
      |> Shiftplaner.get_event!()
      |> Shiftplaner.delete_event()

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: event_path(conn, :index))
  end
end
