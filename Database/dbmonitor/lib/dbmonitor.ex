defmodule Dbmonitor do
  @moduledoc """
  Documentation for `Dbmonitor`.
  """

  def func do
    {:ok, pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "postgres")
    query = Postgrex.prepare!(pid, "", "CREATE TABLE criticalsens (cpufan VARCHAR(20), cpuopt VARCHAR(20))")
    IO.puts(query)
  end
end
