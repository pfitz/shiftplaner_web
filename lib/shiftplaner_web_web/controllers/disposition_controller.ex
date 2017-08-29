defmodule ShiftplanerWebWeb.DispositionController do
  @moduledoc false
  
  use ShiftplanerWebWeb, :controller

  def event_index(conn, _params) do
    events = Shiftplaner.list_all_events()
    render(conn, "event_index.html", events: events)
  end

  def weekend_index(conn, %{"event_id" => id}) do
    event = Shiftplaner.get_event!(id)
    weekends = Shiftplaner.list_weekends_for_event(id)
    render(conn, "weekend_index.html", weekends: weekends, event: event)
  end

  def day_index(conn, %{"event_id" => id, "weekend_id" => w_id}) do
    weekend = Shiftplaner.get_weekend!(w_id)
    days = Shiftplaner.list_days_for_weekend(w_id)
    render(conn, "day_index.html", weekend: weekend, days: days, event_id: id)
  end

  def shift_index(conn, %{"event_id" => id, "weekend_id" => w_id, "day_id" => d_id}) do
    day = Shiftplaner.get_day!(d_id)
    shifts = Shiftplaner.list_shifts_for_day(d_id)
    render(conn, "shift_index.html", event_id: id, weekend_id: w_id, day: day, shifts: shifts)
  end

  def edit(conn, %{"event_id" => id, "weekend_id" => w_id, "day_id" => d_id, "shift_id" => s_id}) do
    shift = Shiftplaner.get_shift!(s_id)
    day = Shiftplaner.get_day!(d_id)
    render(conn, "shift_edit.html",  event_id: id, weekend_id: w_id, day: day, shift: shift)
  end
end
