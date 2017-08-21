defmodule ShiftplanerWebWeb.WeekendController do
  use ShiftplanerWebWeb, :controller

  alias Shiftplaner.{Event, Weekend}

  def index(conn, %{"event_id" => event_id}) do
    weekends = Shiftplaner.list_weekends_for_event(event_id)
    render(conn, "index.html", weekends: weekends, event_id: event_id)
  end

  def new(conn, _params) do
    changeset = Shiftplaner.change_weekend(%Weekend{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"weekend" => weekend_params}) do
    case Shiftplaner.create_weekend(weekend_params) do
      {:ok, weekend} ->
        conn
        |> put_flash(:info, "Weekend created successfully.")
        |> redirect(to: event_weekend_path(conn, :show, weekend))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    weekend = Shiftplaner.get_weekend!(id)
    render(conn, "show.html", weekend: weekend)
  end

  def edit(conn, %{"id" => id}) do
    weekend = Shiftplaner.get_weekend!(id)
    changeset = Shiftplaner.change_weekend(weekend)
    render(conn, "edit.html", weekend: weekend, changeset: changeset)
  end

  def update(conn, %{"id" => id, "weekend" => weekend_params}) do
    weekend = Shiftplaner.get_weekend!(id)

    case Shiftplaner.update_weekend(weekend, weekend_params) do
      {:ok, weekend} ->
        conn
        |> put_flash(:info, "Weekend updated successfully.")
        |> redirect(to: event_weekend_path(conn, :show, weekend))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", weekend: weekend, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    weekend = Shiftplaner.get_weekend!(id)
    {:ok, _weekend} = Shiftplaner.delete_weekend(weekend)

    conn
    |> put_flash(:info, "Weekend deleted successfully.")
    |> redirect(to: event_weekend_path(conn, :index, weekend))
  end
end
