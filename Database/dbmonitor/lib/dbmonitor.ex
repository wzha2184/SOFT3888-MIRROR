defmodule Dbmonitor do
  @moduledoc """
  Documentation for `Dbmonitor`.
  """
    # Example of insertion from terminal:
    # Create data and store as a map:
    #   a = %Dbmonitor.Criticalsens{cpufan: "1000", cpuopt: "0"}
    # Call insertion command:
    #   Dbmonitor.Repo.insert(a)
  defmodule Criticalsens do
    use Ecto.Schema
    alias Dbmonitor.Repo
    import Ecto.Query
    schema "criticalsens" do
      field :cpufan, :string
      field :cpuopt, :string, default: "0"
    end

    def insertCriticalSens do
      a = %Criticalsens{cpufan: "2000", cpuopt: "2300"}
      Repo.insert!(a)
    end

    def getAllData do
      query = from u in "criticalsens",
      select: {u.cpufan, u.cpuopt}
      Repo.all(query)
    end
  end
end
