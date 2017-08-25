defmodule ShiftplanerWebWeb.PersonView do
  alias Shiftplaner.Person
  use ShiftplanerWebWeb, :view

  def availabiltiy(%Person{} = person) do
    "#{Shiftplaner.total_number_of_available_shifts_for_person(person)}/#{Shiftplaner.remaining_number_of_available_shifts_for_person(person)}"
  end
end
