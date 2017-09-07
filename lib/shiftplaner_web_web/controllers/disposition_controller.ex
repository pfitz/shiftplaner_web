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
    render(conn, "shift_edit.html", event_id: id, weekend_id: w_id, day: day, shift: shift)
  end

  def update(
        conn,
        %{
          "event_id" => id,
          "weekend_id" => w_id,
          "day_id" => d_id,
          "shift_id" => s_id,
          "dispo_shift" => disposition
        }
      ) do
    %{griller: griller, worker: worker} = get_griller_and_worker_from_disposition(disposition)

    Shiftplaner.disposition_workers_to_shift(s_id, worker)
    Shiftplaner.disposition_grillers_to_shift(s_id, griller)

    day = Shiftplaner.get_day!(d_id)
    shift = Shiftplaner.get_shift!(s_id)
    conn
    |> render("shift_edit.html", event_id: id, weekend_id: w_id, day: day, shift: shift)
  end

  defp get_griller_and_worker_from_disposition(dispositon) when is_map(dispositon) do
    keys = Map.keys(dispositon)
    griller_keys = Enum.filter(keys, fn key -> String.starts_with?(key, "griller_") end)
    worker_keys = Enum.filter(keys, fn key -> String.starts_with?(key, "worker_") end)

    griller = get_relevant_values_for_keys(dispositon, griller_keys)
    worker = get_relevant_values_for_keys(dispositon, worker_keys)

    %{griller: griller, worker: worker}
  end

  defp get_relevant_values_for_keys(map, list_of_keys) when is_map(map) and is_list(list_of_keys) do
    list_of_keys
    |> Enum.map(&Map.get(map, &1))
    |> Enum.filter(fn id -> String.length(id) > 0 end)
    |> Enum.uniq()
  end
end
