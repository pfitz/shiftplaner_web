defmodule ShiftplanerWebWeb.DayController do
  use ShiftplanerWebWeb, :controller

  alias Shiftplaner.{Day, Weekend}

  def index(conn, %{"event_id" => e_id, "weekend_id" => w_id}) do
    days = Day.list_days()
    render(conn, "index.html", days: days, event_id: e_id, weekend_id: w_id)
  end

  def new(conn, _params) do
    changeset = Day.change_day(%Day{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event_id" => e_id, "weekend_id" => w_id, "day" => day_params}) do
    case Day.create_day(day_params) do
      {:ok, day} ->
        conn
        |> put_flash(:info, "Day created successfully.")
        |> redirect(to: event_weekend_day_path(conn, :show, e_id, w_id, day))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    day = Day.get_day!(id)
    render(conn, "show.html", day: day)
  end

  def edit(conn, %{"id" => id}) do
    day = Day.get_day!(id)
    changeset = Day.change_day(day)
    render(conn, "edit.html", day: day, changeset: changeset)
  end

  def update(conn, %{"event_id" => e_id, "weekend_id" => w_id, "id" => id, "day" => day_params}) do
    day = Day.get_day!(id)

    case Day.update_day(day, day_params) do
      {:ok, day} ->
        conn
        |> put_flash(:info, "Day updated successfully.")
        |> redirect(to: event_weekend_day_path(conn, :show, e_id, w_id, day))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", day: day, changeset: changeset)
    end
  end

  def delete(conn, %{"event_id" => e_id, "weekend_id" => w_id, "id" => id}) do
    day = Day.get_day!(id)
    {:ok, _day} = Day.delete_day(day)

    conn
    |> put_flash(:info, "Day deleted successfully.")
    |> redirect(to: event_weekend_day_path(conn, :index, e_id, w_id))
  end
end
