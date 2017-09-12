defmodule ShiftplanerWebWeb.FrontView do
  @moduledoc false

  use ShiftplanerWebWeb, :view

  def empty_worker_slot(list_of_persons, counter ) do
    list_of_persons
    |> Enum.at(counter - 1)
    |> check_dispositioned()
  end

  defp check_dispositioned(person) when is_nil(person), do: "empty-shift-slot"
  defp check_dispositioned(person), do: ""
end
