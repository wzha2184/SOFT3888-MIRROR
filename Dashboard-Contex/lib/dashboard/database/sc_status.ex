defmodule Dashboard.Database.Sc_status do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sc_status" do
    field :status, :string
    field :info, :string

    timestamps()
  end

  @doc false
  def changeset(sc_status, attrs) do
    sc_status
    |> cast(attrs, [:status, :info])
    |> validate_required([:status, :info])

  end
end
