defmodule ShiftplanerWebWeb.PersonController do
  @moduledoc false

  alias Shiftplaner.Person
  use ShiftplanerWebWeb, :controller

  def index(conn, _params) do
    persons = Person.list_persons()
    render conn, "index.html", persons: persons
  end

  def create(conn, _params) do
    render conn, "create.html"
  end

  @spec delete(Plug.Conn.t, map) :: Plug.Conn.t
  def delete(conn, %{"id" => id}) do
    person = Accounts.get_person!(id)
    {:ok, _person} = Accounts.delete_person(person)

    conn
    |> put_flash(:info, "person deleted successfully.")
    |> redirect(to: Routes.person_path(conn, :index))
  end

  @spec edit(Plug.Conn.t, map) :: Plug.Conn.t
  def edit(conn, %{"id" => id}) do
    person = Accounts.get_person!(id)
    changeset = Accounts.change_person(person)
    render(conn, "edit.html", person: person, changeset: changeset)
  end
end
