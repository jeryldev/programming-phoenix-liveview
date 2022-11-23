defmodule Pento.Survey.Demographic.Query do
  import Ecto.Query

  alias Pento.Survey.Demographic

  # Constructor
  # they are functions which shows the concept of a base query
  # and which provide one common way to build the foundation
  # for all __MODULE__ queries
  def base do
    Demographic
  end

  # Reducer
  # they are functions that take some type along
  # with additional arguments, and apply those additional
  # arguments to return the same type.
  def for_user(query \\ base(), user) do
    query
    |> where([d], d.user_id == ^user.id)
  end
end
