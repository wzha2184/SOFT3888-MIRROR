defmodule Dashboard.Dbmonitor do
  @moduledoc """
  Documentation for `Dbmonitor`.
  """
    # Example of insertion from terminal:
    # Create data and store as a map:
    #   a = %Dbmonitor.Dbmonitor.Criticalsens{cpufan: "1000", cpuopt: "0"}
    # Call insertion command:
    #   Dbmonitor.Repo.insert(a)
  defmodule Criticalsens do
    use Ecto.Schema
    alias Dashboard.Repo
    schema "criticalsens" do
      field :cpufan, :string
      field :cpuopt, :string, default: "0"
    end

    def insertS do
      a = %Criticalsens{cpufan: "2000", cpuopt: "2300"}
      Repo.insert(a)
    end
  end
end
