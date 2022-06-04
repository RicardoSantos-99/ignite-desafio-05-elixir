defmodule Flightex.Users.CreateOrUpdate do
  alias Flightex.Users
  alias Users.Agent, as: UserAgent
  alias Users.User

  def call(%{id: _id, name: _name, email: _email, cpf: cpf}) when is_integer(cpf) do
    {:error, "cpf is integer"}
  end

  def call(%{id: id, name: name, email: email, cpf: cpf}) do
    User.build(name, email, cpf, id)
    |> save_user()
  end

  defp save_user({:ok, %User{} = user}) do
    UserAgent.save(user)

    {:ok, "User created or updated successfully"}
  end

  defp save_user({:error, _reason} = error), do: error
end
