defmodule Dbmonitor do
  @moduledoc """
  Documentation for `Dbmonitor`.
  """

  def func do
    Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "postgres")
  end
end
