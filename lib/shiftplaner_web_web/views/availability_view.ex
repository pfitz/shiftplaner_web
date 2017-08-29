defmodule ShiftplanerWebWeb.AvailabilityView do
  use ShiftplanerWebWeb, :view

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

  def person_is_available_for_shift?(person_id, %Shift{} = shift) do
    avl_shifts = Person.list_available_shifts_for_person(person_id)
    Enum.member?(avl_shifts, shift.id)
  end

end
