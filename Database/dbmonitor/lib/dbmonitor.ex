defmodule Dbmonitor do
  @moduledoc """
  Documentation for `Dbmonitor`.
  """
    use Ecto.Schema
    alias Dbmonitor.Repo
    schema "criticalsens" do
      field :cpufan, :string
      field :cpuopt, :string, default: "0"
    end

    def insertS do
      a = %Dbmonitor{cpufan: "1000", cpuopt: "0"}
      Repo.insert(a)
    end
  end
  # Example of insertion from terminal:
  # Create data and store as a map:
  #   a = %Dbmonitor.Dbmonitor.Criticalsens{cpufan: "1000", cpuopt: "0"}
  # Call insertion command:
  #   Dbmonitor.Repo.insert(a)
