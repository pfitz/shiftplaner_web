defmodule ShiftplanerWebWeb.WeekendView do
  use ShiftplanerWebWeb, :view
  alias Shiftplaner.{Day, Weekend}

  def weekend_from(%Weekend{} = weekend) do
    {from, _} = Weekend.first_and_last_day_of_weekend(weekend)
    date_to_string(from)
  end

  def weekend_to(%Weekend{} = weekend) do
    {_, to} = Weekend.first_and_last_day_of_weekend(weekend)
    date_to_string(to)
  end

  defp date_to_string(date) do
    {y,m,d} = Date.to_erl(date)
    "#{d}.#{m}.#{y}"
  end
end
