defmodule ShiftplanerWebWeb.ShiftController do
  use ShiftplanerWebWeb, :controller

  alias Shiftplaner.Shift

  def index(
        conn,
        %{
          "event_id" => e_id,
          "weekend_id" => w_id,
          "day_id" => d_id
        }
      ) do
    shifts = Shiftplaner.list_shifts_for_day(d_id)
    render(conn, "index.html", shifts: shifts, event_id: e_id, weekend_id: w_id, day_id: d_id)
  end

  def new(conn, %{
    "event_id" => e_id,
    "weekend_id" => w_id,
    "day_id" => d_id
  }) do
    changeset = Shiftplaner.change_shift(%Shift{})
    render(conn, "new.html", changeset: changeset, event_id: e_id, weekend_id: w_id, day_id: d_id)
  end

  def create(
        conn,
        %{
          "event_id" => e_id,
          "weekend_id" => w_id,
          "day_id" => d_id,
          "shift" => shift_params
        }
      ) do
    shift_params = Map.put(shift_params, "day_id", d_id)
    case Shiftplaner.create_shift(shift_params) do
      {:ok, shift} ->
        conn
        |> put_flash(:info, "Shift created successfully.")
        |> redirect(to: event_weekend_day_shift_path(conn, :show, e_id, w_id, d_id, shift))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(
        conn,
        %{
          "event_id" => e_id,
          "weekend_id" => w_id,
          "day_id" => d_id,
          "id" => id
        }
      ) do
    shift = Shiftplaner.get_shift!(id)
    render(conn, "show.html", shift: shift, event_id: e_id, weekend_id: w_id, day_id: d_id)
  end

  def edit(
        conn,
        %{
          "event_id" => e_id,
          "weekend_id" => w_id,
          "day_id" => d_id,
          "id" => id
        }
      ) do
    shift = Shiftplaner.get_shift!(id)
    changeset = Shiftplaner.change_shift(shift)
    render(conn, "edit.html", shift: shift, changeset: changeset, event_id: e_id, weekend_id: w_id, day_id: d_id)
  end

  def update(
        conn,
        %{
          "event_id" => e_id,
          "weekend_id" => w_id,
          "day_id" => d_id,
          "id" => id,
          "shift" => shift_params
        }
      ) do
    shift = Shiftplaner.get_shift!(id)

    case Shiftplaner.update_shift(shift, shift_params) do
      {:ok, shift} ->
        conn
        |> put_flash(:info, "Shift updated successfully.")
        |> redirect(to: event_weekend_day_shift_path(conn, :show, e_id, w_id, d_id, shift))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", shift: shift, changeset: changeset)
    end
  end

  def delete(
        conn,
        %{
          "event_id" => e_id,
          "weekend_id" => w_id,
          "day_id" => d_id,
          "id" => id
        }
      ) do
    shift = Shiftplaner.get_shift!(id)
    {:ok, _shift} = Shiftplaner.delete_shift(shift)

    conn
    |> put_flash(:info, "Shift deleted successfully.")
    |> redirect(to: event_weekend_day_shift_path(conn, :index, e_id, w_id, d_id))
  end
end
