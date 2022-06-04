defmodule Flightex.Bookings.CreateOrUpdate do
  alias Flightex.Bookings.Booking
  alias Flightex.Bookings.Agent, as: BookingsAgent
  alias Flightex.Users.Agent, as: UsersAgent

  def call(%{
        complete_date: complete_date,
        local_origin: local_origin,
        local_destination: local_destination,
        user_id: user_id
      }) do
    with {:ok, user} <- UsersAgent.get(user_id),
         {:ok, booking} <- Booking.build(complete_date, local_origin, local_destination, user) do
      BookingsAgent.save(booking)
    else
      error -> error
    end
  end
end
