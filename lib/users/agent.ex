defmodule Flightex.Users.Agent do
  use Agent

  alias Flightex.Users.User

  # coveralls-ignore-start
  def start_link(_initial_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  # coveralls-ignore-stop

  def save(%User{} = user) do
    Agent.update(__MODULE__, &update_state(&1, user))
    {:ok, user}
  end

  def get(cpf), do: Agent.get(__MODULE__, &get_user(&1, cpf))

  def get_by_uuid(uuid),
    do: Agent.get(__MODULE__, &get_user_by_uuid(&1, uuid))

  def get_all, do: {:ok, Agent.get(__MODULE__, & &1)}

  defp get_user(state, cpf) do
    case Map.get(state, cpf) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  defp get_user_by_uuid(state, uuid) do
    IO.inspect(state)

    case get_user_in_state(state, uuid) do
      [] -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  def get_user_in_state(state, uuid) do
    user =
      state
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&tl/1)
      |> Enum.map(&hd/1)
      |> Enum.filter(fn user -> user.uuid == uuid end)

    IO.inspect(user)
    get_first_list_elem(user)
  end

  defp get_first_list_elem(list) when length(list) == 1 do
    hd(list)
  end

  defp get_first_list_elem(list) do
    list
  end

  defp update_state(state, %User{cpf: cpf} = user), do: Map.put(state, cpf, user)
end
