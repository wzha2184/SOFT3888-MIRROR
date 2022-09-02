defmodule Dbmonitor do
  @moduledoc """
  Documentation for `Dbmonitor`.
  """
  defmodule Dbmonitor.Criticalsens do
    use Ecto.Schema
    schema "criticalsens" do
      field :cpufan, :string
      field :cpuopt, :string, default: "0"
    end
  end
end
