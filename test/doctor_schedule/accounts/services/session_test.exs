defmodule DoctorSchedule.Accounts.Services.SessionTest do
  use DoctorSchedule.DataCase

  alias DoctorSchedule.Accounts.Repositories.AccountRepository
  alias DoctorSchedule.Accounts.Services.Session

  describe "users" do
    alias DoctorSchedule.UserFixture

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(UserFixture.valid_user())
        |> AccountRepository.create_user()

      user
    end

    test "authenticate/2 should return user" do
      user_fixture()
      {:ok, user_authenticate} = Session.authenticate("viana.mail@gmail.com", "123456")
      assert "viana.mail@gmail.com" == user_authenticate.email
    end

    test "authenticate/2 should return unauthorized" do
      user_fixture()
      {:error, :unauthorized} = Session.authenticate("viana.mail@gmail.com", "fdr4rdd")
    end

    test "authenticate/2 should return not_found" do
      result = Session.authenticate("vfghjjl@gmail.com", "123456")
      assert {:error, :not_found} == result
    end
  end
end
