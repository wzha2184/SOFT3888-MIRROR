defmodule Dashboard.Database.CpuFreq do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cpu_freq" do
    field :cpu_current_freq, :decimal
    field :cpu_max_freq, :decimal
    field :cpu_min_freq, :decimal
    field :sc_num, :decimal

    timestamps()
  end

  @doc false
  def changeset(cpu_freq, attrs) do
    cpu_freq
    |> cast(attrs, [:cpu_current_freq, :cpu_min_freq, :cpu_max_freq, :sc_num])
    |> validate_required([:cpu_current_freq, :cpu_min_freq, :cpu_max_freq, :sc_num])
  end
end
