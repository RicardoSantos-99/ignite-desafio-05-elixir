defmodule Flightex.Users.Agent do
  alias Flightex.Users.User

  use Agent

  def start_link(_initial_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%User{} = user) do
    Agent.update(__MODULE__, &update_state(&1, user))
  end

  def get(uuid), do: Agent.get(__MODULE__, &get_user(&1, uuid))

  defp get_user(state, uuid) do
    case Map.get(state, uuid) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  defp update_state(state, %User{id: uuid} = user), do: Map.put(state, uuid, user)
end
