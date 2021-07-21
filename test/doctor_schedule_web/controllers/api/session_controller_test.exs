defmodule DoctorScheduleWeb.Api.SessionControllerTest do
  use DoctorScheduleWeb.ConnCase

  alias DoctorSchedule.Accounts.Repositories.AccountRepository

  alias DoctorSchedule.UserFixture

  import DoctorScheduleWeb.Auth.Guardian

  def fixture(:user) do
    {:ok, user} = AccountRepository.create_user(UserFixture.valid_user())
    user
  end

  setup %{conn: conn} do
    {:ok, user} = AccountRepository.create_user(UserFixture.auth_user())
    {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "bearer " <> token)

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "session tests" do
    test "should authenticated with valid user", %{conn: conn} do
      conn =
        conn
        |> post(Routes.api_session_path(conn, :create), %{
          email: "viana.auth@gmail.com",
          password: "123456"
        })

      assert json_response(conn, 201)["user"]["email"] == "viana.auth@gmail.com"
    end

    test "should not authenticated with invalid user", %{conn: conn} do
      conn =
        conn
        |> post(Routes.api_session_path(conn, :create), %{
          email: "vi@gmail.com",
          password: "123456"
        })

      assert json_response(conn, 400) == %{"message" => "unauthorized"}
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
