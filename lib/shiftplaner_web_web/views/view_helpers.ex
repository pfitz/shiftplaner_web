defmodule ShiftplanerWebWeb.ViewHelpers do
  @moduledoc false

  alias Shiftplaner.{Day, Person, Shift, Weekend}

  def weekend_description(%Weekend{} = weekend) do
    {start, ende} = Weekend.first_and_last_day_of_weekend(weekend)
    {_, s_month, s_day} = Date.to_erl(start)
    {_, e_month, e_day} = Date.to_erl(ende)
    "Wochenende von #{prefix_zero_if_needed(s_day)}.#{prefix_zero_if_needed(s_month)} bis #{
      prefix_zero_if_needed(e_day)
    }.#{prefix_zero_if_needed(e_month)}"
  end

  def day_of_week(%Day{} = day) do
    case _day_of_week = Date.day_of_week(day.date) do
      1 -> "Montag"
      2 -> "Dienstag"
      3 -> "Mittwoch"
      4 -> "Donnestag"
      5 -> "Freitag"
      6 -> "Samstag"
      7 -> "Sonntag"
    end
  end

  def shift_times(%Shift{} = shift) do
    {s_hour, _, _} = Time.to_erl(shift.start_time)
    {e_hour, _, _} = Time.to_erl(shift.end_time)
    "#{prefix_zero_if_needed(s_hour)} Uhr bis #{prefix_zero_if_needed(e_hour)} Uhr"
  end

  def prefix_zero_if_needed(integer) when integer >= 10, do: integer
  def prefix_zero_if_needed(integer) when integer < 10 do
    "0#{integer}"
  end

  def weekend_from(%Weekend{} = weekend) do
    {from, _} = Weekend.first_and_last_day_of_weekend(weekend)
    date_to_string(from)
  end

  def weekend_to(%Weekend{} = weekend) do
    {_, to} = Weekend.first_and_last_day_of_weekend(weekend)
    date_to_string(to)
  end

  def date_to_string(:no_days) do
    "-"
  end

  def date_to_string(date) do
    {y,m,d} = Date.to_erl(date)
    "#{prefix_zero_if_needed(d)}.#{prefix_zero_if_needed(m)}.#{y}"
  end

  def date_to_short_string(date) do
    {y, m, d} = Date.to_erl(date)
    "#{prefix_zero_if_needed(d)}.#{prefix_zero_if_needed(m)}."
  end

  def dispositioned_worker_or_empty(%Shift{} = shift, counter) when is_integer(counter) do
    dispositioned_or_empty(shift.dispositioned_persons, counter)
  end

  def dispositioned_griller_or_empty(%Shift{} = shift, counter) when is_integer(counter) do
    dispositioned_or_empty(shift.dispositioned_griller, counter)
  end

  defp dispositioned_or_empty(list_of_persons, counter) when  is_list(list_of_persons) and is_integer(counter) and counter > 0 do
    list_of_persons
    |> Enum.at(counter - 1)
    |> check_if_dispositioned()
  end

  defp check_if_dispositioned(person) when is_nil(person), do: " - "
  defp check_if_dispositioned(%Person{} = person) do
    "#{person.first_name} #{person.sure_name}"
  end

  def time_to_string(%Time{} = time) do
    "#{prefix_zero_if_needed(time.hour)}:#{prefix_zero_if_needed(time.minute)}"
  end
end
