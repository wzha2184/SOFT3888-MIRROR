defmodule Dashboard.Database.ServerStatus do
  use Ecto.Schema
  import Ecto.Changeset

  schema "server_status" do
    field :type, :string
    field :sc_num, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(sc_status, attrs) do
    sc_status
    |> cast(attrs, [:type, :sc_num, :status])
    |> validate_required([:type, :sc_num, :status])

  end
end
