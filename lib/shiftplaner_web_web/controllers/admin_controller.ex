defmodule ShiftplanerWebWeb.AdminController do
  @moduledoc false

  use ShiftplanerWebWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

end
