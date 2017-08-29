defmodule ShiftplanerWebWeb.AvailabilityView do
  use ShiftplanerWebWeb, :view

  alias Shiftplaner.{Person, Shift}

  def person_is_available_for_shift?(person_id, %Shift{} = shift) do
    avl_shifts = Person.list_available_shift_ids_for_person_id(person_id)
    Enum.member?(avl_shifts, shift.id)
  end

end
