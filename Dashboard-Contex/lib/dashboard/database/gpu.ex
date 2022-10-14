defmodule Dashboard.Database.Gpu do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gpu" do
    field :BIOS, :string
    field :MaxStreamingMultiprocessorFrequency, :decimal
    field :MaxgraphicsFrequency, :decimal
    field :MaxmemoryFrequency, :decimal
    field :Name, :string
    field :StreamingMultiprocessorFrequency, :decimal
    field :Temperature, :decimal
    field :UUID, :string
    field :fanSpeed, :decimal
    field :freeMemory, :decimal
    field :graphicsFrequency, :decimal
    field :limitPower, :decimal
    field :maxLimitPower, :decimal
    field :memoryFrequency, :decimal
    field :minLimitPower, :decimal
    field :power, :decimal
    field :totalMemory, :decimal
    field :usedMemory, :decimal
    field :sc_num, :decimal

    timestamps()
  end

  @doc false
  def changeset(gpu, attrs) do
    gpu
    |> cast(attrs, [:BIOS,:MaxStreamingMultiprocessorFrequency, :MaxgraphicsFrequency, :MaxmemoryFrequency, :Name,
    :StreamingMultiprocessorFrequency, :Temperature, :UUID, :fanSpeed, :freeMemory, :graphicsFrequency, :limitPower,
    :maxLimitPower, :memoryFrequency, :minLimitPower, :power, :totalMemory, :usedMemory, :sc_num])
    |> validate_required([:BIOS,:MaxStreamingMultiprocessorFrequency, :MaxgraphicsFrequency, :MaxmemoryFrequency, :Name,
    :StreamingMultiprocessorFrequency, :Temperature, :UUID, :fanSpeed, :freeMemory, :graphicsFrequency, :limitPower,
    :maxLimitPower, :memoryFrequency, :minLimitPower, :power, :totalMemory, :usedMemory, :sc_num])

  end
end
