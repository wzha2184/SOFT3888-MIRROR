defmodule Dashboard.Database.ServerStatus do
  use Ecto.Schema
  import Ecto.Changeset

  schema "server_status" do
    field :type, :string
    field :super_cluster_number, :decimal
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(sc_status, attrs) do
    sc_status
    |> cast(attrs, [:type, :super_cluster_number, :status])
    |> validate_required([:type, :super_cluster_number, :status])

  end
end
