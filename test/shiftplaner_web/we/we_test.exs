defmodule ShiftplanerWeb.WETest do
  use ShiftplanerWeb.DataCase

  alias ShiftplanerWeb.WE

  describe "weekends" do
    alias ShiftplanerWeb.WE.Weekend

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def weekend_fixture(attrs \\ %{}) do
      {:ok, weekend} =
        attrs
        |> Enum.into(@valid_attrs)
        |> WE.create_weekend()

      weekend
    end

    test "list_weekends/0 returns all weekends" do
      weekend = weekend_fixture()
      assert WE.list_weekends() == [weekend]
    end

    test "get_weekend!/1 returns the weekend with given id" do
      weekend = weekend_fixture()
      assert WE.get_weekend!(weekend.id) == weekend
    end

    test "create_weekend/1 with valid data creates a weekend" do
      assert {:ok, %Weekend{} = weekend} = WE.create_weekend(@valid_attrs)
    end

    test "create_weekend/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WE.create_weekend(@invalid_attrs)
    end

    test "update_weekend/2 with valid data updates the weekend" do
      weekend = weekend_fixture()
      assert {:ok, weekend} = WE.update_weekend(weekend, @update_attrs)
      assert %Weekend{} = weekend
    end

    test "update_weekend/2 with invalid data returns error changeset" do
      weekend = weekend_fixture()
      assert {:error, %Ecto.Changeset{}} = WE.update_weekend(weekend, @invalid_attrs)
      assert weekend == WE.get_weekend!(weekend.id)
    end

    test "delete_weekend/1 deletes the weekend" do
      weekend = weekend_fixture()
      assert {:ok, %Weekend{}} = WE.delete_weekend(weekend)
      assert_raise Ecto.NoResultsError, fn -> WE.get_weekend!(weekend.id) end
    end

    test "change_weekend/1 returns a weekend changeset" do
      weekend = weekend_fixture()
      assert %Ecto.Changeset{} = WE.change_weekend(weekend)
    end
  end
end
