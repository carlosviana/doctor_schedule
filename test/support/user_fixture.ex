defmodule DoctorSchedule.UserFixture do
  def valid_user,
    do: %{
      email: "viana.mail@gmail.com",
      first_name: "some first_name",
      last_name: "some last_name",
      password: "123456",
      password_confirmation: "123456"
    }

  def update_user,
    do: %{
      email: "viana@gmail.com",
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      password: "123456",
      password_confirmation: "123456"
    }

  def invalid_user,
    do: %{email: nil, first_name: nil, last_name: nil, password_hash: nil, role: nil}
end
