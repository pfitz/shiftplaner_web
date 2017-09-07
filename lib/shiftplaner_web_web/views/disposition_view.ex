defmodule ShiftplanerWebWeb.DispositionView do
  alias Shiftplaner.Shift
  use ShiftplanerWebWeb, :view
  import Phoenix.HTML.Form

  def select_available_griller(f, count,  %Shift{} = shift) do
    available_griller = shift.available_persons
    dispositioned_griller = shift.dispositioned_griller
    select(f, String.to_atom("griller_#{count}"), Enum.map(available_griller, &{"#{&1.first_name} #{&1.sure_name}", &1.id}), prompt: "Bitte Griller auswählen:", selected: select_person(dispositioned_griller, count))
  end

  def select_available_worker(f, count,  %Shift{} = shift) do
    available_worker = shift.available_persons
    dispositioned_worker = shift.dispositioned_persons
    select(f, String.to_atom("worker_#{count}"), Enum.map(available_worker, &{"#{&1.first_name} #{&1.sure_name}", &1.id}), prompt: "Bitte Arbeiter auswählen:", selected: select_person(dispositioned_worker, count))
  end

  defp select_person(available_workers, index) do
    IO.inspect available_workers
    case Enum.at(available_workers, index - 1) do
      nil -> ""
      worker -> worker.id
    end
  end

end
