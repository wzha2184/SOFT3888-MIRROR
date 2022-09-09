defmodule Dashboard.Database.CpuFreq do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cpu_freq" do
    field :cpu_current_freq, :decimal
    field :cpu_max_freq, :decimal
    field :cpu_min_freq, :decimal

    timestamps()
  end

  @doc false
  def changeset(cpu_freq, attrs) do
    cpu_freq
    |> cast(attrs, [:cpu_current_freq, :cpu_min_freq, :cpu_max_freq])
    |> validate_required([:cpu_current_freq, :cpu_min_freq, :cpu_max_freq])
  end
end
