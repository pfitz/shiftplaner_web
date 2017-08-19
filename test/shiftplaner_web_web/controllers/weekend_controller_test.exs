defmodule ShiftplanerWeb.WeekendControllerTest do
  use ShiftplanerWeb.ConnCase

  alias ShiftplanerWeb.WE

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:weekend) do
    {:ok, weekend} = WE.create_weekend(@create_attrs)
    weekend
  end

  describe "index" do
    test "lists all weekends", %{conn: conn} do
      conn = get conn, weekend_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Weekends"
    end
  end

  describe "new weekend" do
    test "renders form", %{conn: conn} do
      conn = get conn, weekend_path(conn, :new)
      assert html_response(conn, 200) =~ "New Weekend"
    end
  end

  describe "create weekend" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, weekend_path(conn, :create), weekend: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == weekend_path(conn, :show, id)

      conn = get conn, weekend_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Weekend"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, weekend_path(conn, :create), weekend: @invalid_attrs
      assert html_response(conn, 200) =~ "New Weekend"
    end
  end

  describe "edit weekend" do
    setup [:create_weekend]

    test "renders form for editing chosen weekend", %{conn: conn, weekend: weekend} do
      conn = get conn, weekend_path(conn, :edit, weekend)
      assert html_response(conn, 200) =~ "Edit Weekend"
    end
  end

  describe "update weekend" do
    setup [:create_weekend]

    test "redirects when data is valid", %{conn: conn, weekend: weekend} do
      conn = put conn, weekend_path(conn, :update, weekend), weekend: @update_attrs
      assert redirected_to(conn) == weekend_path(conn, :show, weekend)

      conn = get conn, weekend_path(conn, :show, weekend)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, weekend: weekend} do
      conn = put conn, weekend_path(conn, :update, weekend), weekend: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Weekend"
    end
  end

  describe "delete weekend" do
    setup [:create_weekend]

    test "deletes chosen weekend", %{conn: conn, weekend: weekend} do
      conn = delete conn, weekend_path(conn, :delete, weekend)
      assert redirected_to(conn) == weekend_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, weekend_path(conn, :show, weekend)
      end
    end
  end

  defp create_weekend(_) do
    weekend = fixture(:weekend)
    {:ok, weekend: weekend}
  end
end
