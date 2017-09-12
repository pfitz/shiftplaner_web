defmodule ShiftplanerWebWeb.DispositionView do
  alias Shiftplaner.Shift
  use ShiftplanerWebWeb, :view
  import Phoenix.HTML.Form

  def select_available_griller(f, count, %Shift{} = shift) do
    available_griller = shift.available_persons
                        |> Enum.filter(fn person -> person.is_griller end)
    dispositioned_griller = shift.dispositioned_griller
    select(
      f,
      String.to_atom("griller_#{count}"),
      sort_and_enrich(available_griller),
      prompt: "Bitte Griller auswählen:",
      selected: select_person(dispositioned_griller, count)
    )
  end

  def select_available_worker(f, count, %Shift{} = shift) do
    available_worker = shift.available_persons
    dispositioned_worker = shift.dispositioned_persons

    select(
      f,
      String.to_atom("worker_#{count}"),
      sort_and_enrich(available_worker),
      prompt: "Bitte Arbeiter auswählen:",
      selected: select_person(dispositioned_worker, count)
    )
  end

  defp sort_and_enrich(list_of_workers) do
    list_of_workers
    |> Enum.map(
         fn worker ->
           person = Shiftplaner.get_person!(worker.id)
           avl_shifts_number = Shiftplaner.total_number_of_available_shifts_for_person(person)
           rem_shifts_number = Shiftplaner.remaining_number_of_available_shifts_for_person(person)
           {person, avl_shifts_number, rem_shifts_number}
         end
       )
    |> Enum.sort(&sorter(&1,&2))
    |> Enum.map(fn {p, a, r} -> {"#{p.first_name} #{p.sure_name} - #{a}/#{r}", p.id}  end)
  end

  defp select_person(available_workers, index) do
    case Enum.at(available_workers, index - 1) do
      nil -> ""
      worker -> worker.id
    end
  end

  defp sorter({_,_,r1}, {_,_,r2}) when r1 == 0 or r2 == 0, do: false
  defp sorter({_,a1,_}, {_,a2,_}) when a1 < a2, do: true
  defp sorter({_,a1,_}, {_,a2,_}) when a1 > a2, do: false
  defp sorter({_,a1, r1}, {_,a2,r2}) when a1 == a2 do
    r1 >= r2
  end
end
