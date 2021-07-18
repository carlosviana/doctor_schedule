defmodule DoctorSchedule.Accounts.Entities.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "users" do
    field :email, :string, unique: true
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :role, :string, default: "user"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :role, :password, :password_confirmation])
    |> validate_required(
      [
        :email,
        :first_name,
        :last_name,
        :role,
        :password,
        :password_confirmation
      ],
      message: "campo não pode ficar em branco"
    )
    |> unique_constraint(:email, message: "já existe este e-mail cadastrado")
    |> validate_format(:email, ~r/@/, message: "formato do email é inválido")
    |> update_change(:email, &String.downcase/1)
    |> validate_length(:password_hash,
      min: 6,
      max: 12,
      message: "a senha deve ter entre 6 e 12 caracteres"
    )
    |> validate_confirmation(:password)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp hash_password(changeset) do
    changeset
  end
end
