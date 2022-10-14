defmodule Dashboard.Cpu do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cpu_info" do
    field :CPU_ECC, :string
    field :CPU_FAN, :string
    field :CPU_OPT, :string
    field :Memory_Train_ERR, :string
    field :Watchdog2, :string
    field :sc_num, :decimal

    timestamps()
  end

  @doc false
  def changeset(cpu, attrs) do
    cpu
    |> cast(attrs, [:CPU_FAN, :CPU_OPT, :CPU_ECC, :Memory_Train_ERR, :Watchdog2, :sc_num])
    |> validate_required([:CPU_FAN, :CPU_OPT, :CPU_ECC, :Memory_Train_ERR, :Watchdog2, :sc_num])
  end
end
