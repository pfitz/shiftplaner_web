defmodule ShiftplanerWebWeb.DayController do
  use ShiftplanerWebWeb, :controller

  alias Shiftplaner.Day

  def index(conn, %{"event_id" => e_id, "weekend_id" => w_id}) do
    we = Shiftplaner.get_weekend!(w_id)
    days = Shiftplaner.list_days_for_weekend(w_id)
    render(conn, "index.html", days: days, event_id: e_id, weekend: we)
  end

  def new(conn, %{"event_id" => e_id, "weekend_id" => w_id}) do
    changeset = Shiftplaner.change_day(%Day{})
    render(conn, "new.html", changeset: changeset, event_id: e_id, weekend_id: w_id)
  end

  def create(conn, %{"event_id" => e_id, "weekend_id" => w_id, "day" => day_params}) do
    day_params = Map.put(day_params, "weekend_id", w_id)
    case Shiftplaner.create_day(day_params) do
      {:ok, day} ->
        conn
        |> put_flash(:info, "Day created successfully.")
        |> redirect(to: event_weekend_day_path(conn, :show, e_id, w_id, day))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"event_id" => e_id, "weekend_id" => w_id, "id" => id}) do
    day = Shiftplaner.get_day!(id)
    render(conn, "show.html", day: day, event_id: e_id, weekend_id: w_id)
  end

  def edit(conn, %{"event_id" => e_id, "weekend_id" => w_id, "id" => id}) do
    day = Shiftplaner.get_day!(id)
    changeset = Shiftplaner.change_day(day)
    render(conn, "edit.html", day: day, changeset: changeset, event_id: e_id, weekend_id: w_id)
  end

  def update(conn, %{"event_id" => e_id, "weekend_id" => w_id, "id" => id, "day" => day_params}) do
    day = Shiftplaner.get_day!(id)

    case Shiftplaner.update_day(day, day_params) do
      {:ok, day} ->
        conn
        |> put_flash(:info, "Day updated successfully.")
        |> redirect(to: event_weekend_day_path(conn, :show, e_id, w_id, day))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", day: day, changeset: changeset)
    end
  end

  def delete(conn, %{"event_id" => e_id, "weekend_id" => w_id, "id" => id}) do
    day = Shiftplaner.get_day!(id)
    {:ok, _day} = Shiftplaner.delete_day(day)

    conn
    |> put_flash(:info, "Day deleted successfully.")
    |> redirect(to: event_weekend_day_path(conn, :index, e_id, w_id))
  end
end
