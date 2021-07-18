defmodule DoctorSchedule.Accounts.Repositories.AccountRepositoryTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Accounts.Repositories.AccountRepository

  describe "users" do
    alias DoctorSchedule.Accounts.Entities.User

    @valid_attrs %{
      email: "viana.mail@gmail.com",
      first_name: "some first_name",
      last_name: "some last_name",
      password: "123456",
      password_confirmation: "123456"
    }
    @update_attrs %{
      email: "viana@gmail.com",
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      password: "123456",
      password_confirmation: "123456"
    }
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, password_hash: nil, role: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AccountRepository.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user_fixture()
      assert AccountRepository.list_users() |> Enum.count() == 1
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert AccountRepository.get_user!(user.id).email == user.email
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = AccountRepository.create_user(@valid_attrs)
      assert user.email == "viana.mail@gmail.com"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      response = AccountRepository.create_user(@invalid_attrs)
      assert {:error, %Ecto.Changeset{}} = response
      {:error, changeset} = response
      assert "campo não pode ficar em branco" in errors_on(changeset).email
      assert %{email: ["campo não pode ficar em branco"]} = errors_on(changeset)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = AccountRepository.update_user(user, @update_attrs)
      assert user.email == "viana@gmail.com"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} = AccountRepository.update_user(user, @invalid_attrs)
      assert user.email == AccountRepository.get_user!(user.id).email
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = AccountRepository.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> AccountRepository.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = AccountRepository.change_user(user)
    end
  end
end
