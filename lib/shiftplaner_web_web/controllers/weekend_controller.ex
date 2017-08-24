defmodule ShiftplanerWebWeb.WeekendController do
  use ShiftplanerWebWeb, :controller

  alias Shiftplaner.{Event, Weekend}

  def index(conn, %{"event_id" => event_id}) do
    {:ok, event} = Shiftplaner.get_event(event_id)
    weekends = Shiftplaner.list_weekends_for_event(event_id)
    render(conn, "index.html", weekends: weekends, event: event)
  end

  def new(conn, %{"event_id" => event_id}) do
    {:ok, event} = Shiftplaner.get_event(event_id)
    changeset = Shiftplaner.change_weekend(%Weekend{})
    render(conn, "new.html", changeset: changeset, event: event)
  end

  def create(conn, %{"event_id" => event_id, "weekend" => weekend_params}) do

    case Shiftplaner.create_weekend_for_event(weekend_params, event_id) do
      {:ok, weekend} ->
        conn
        |> put_flash(:info, "Weekend created successfully.")
        |> redirect(to: event_weekend_path(conn, :show, event_id, weekend))
      {:error, %Ecto.Changeset{} = changeset} ->
        event = Shiftplaner.get_event(event_id)
        render(conn, "new.html", changeset: changeset, event: event)
    end
  end

  def show(conn, %{"event_id" => event_id, "id" => id}) do
    event = Shiftplaner.get_event!(event_id)
    weekend = Shiftplaner.get_weekend!(id)
    render(conn, "show.html", weekend: weekend, event: event)
  end

  def edit(conn, %{"event_id" => event_id, "id" => id}) do
    weekend = Shiftplaner.get_weekend!(id)
    event = Shiftplaner.get_event!(event_id)
    changeset = Shiftplaner.change_weekend(weekend)
    render(conn, "edit.html", weekend: weekend, changeset: changeset, event: event)
  end

  def update(conn, %{"event_id" => event_id, "id" => id, "weekend" => weekend_params}) do
    weekend = Shiftplaner.get_weekend!(id)

    case Shiftplaner.update_weekend(weekend, weekend_params) do
      {:ok, weekend} ->
        conn
        |> put_flash(:info, "Weekend updated successfully.")
        |> redirect(to: event_weekend_path(conn, :show, event_id, weekend.id))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", weekend: weekend, changeset: changeset)
    end
  end

  def delete(conn, %{"event_id" => event_id, "id" => id}) do
    weekend = Shiftplaner.get_weekend!(id)
    {:ok, _weekend} = Shiftplaner.delete_weekend(weekend)

    conn
    |> put_flash(:info, "Weekend deleted successfully.")
    |> redirect(to: event_weekend_path(conn, :index, event_id))
  end
end
