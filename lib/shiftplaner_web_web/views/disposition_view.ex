defmodule ShiftplanerWebWeb.DispositionView do
  alias Shiftplaner.Shift
  use ShiftplanerWebWeb, :view
  import Phoenix.HTML.Form

  def select_available_griller(f, count,  %Shift{} = shift) do
    available_griller = Shift.list_available_griller_for_shift(shift)
    select(f, String.to_atom("griller_#{count}"), Enum.map(available_griller, &{"#{&1.first_name} #{&1.sure_name}", &1.id}), prompt: "Bitte Griller auswählen:")
  end

  def select_available_worker(f, count,  %Shift{} = shift) do
    available_worker = Shift.list_available_worker_for_shift(shift)
    select(f, String.to_atom("worker_#{count}"), Enum.map(available_worker, &{"#{&1.first_name} #{&1.sure_name}", &1.id}), prompt: "Bitte Arbeiter auswählen:")
  end

end
