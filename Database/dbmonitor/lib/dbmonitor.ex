defmodule Dbmonitor do
  @moduledoc """
  Documentation for `Dbmonitor`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Dbmonitor.hello()
      :world

  """
  def func do
    Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "postgres")
  end
end
