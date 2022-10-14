defmodule Dashboard.Repo.Migrations.CreateGpu do
  use Ecto.Migration

  def change do
    create table(:gpu) do
      add :BIOS, :string
      add :MaxStreamingMultiprocessorFrequency, :decimal
      add :MaxgraphicsFrequency, :decimal
      add :MaxmemoryFrequency, :decimal
      add :Name, :string
      add :StreamingMultiprocessorFrequency, :decimal
      add :Temperature, :decimal
      add :UUID, :string
      add :fanSpeed, :decimal
      add :freeMemory, :decimal
      add :graphicsFrequency, :decimal
      add :limitPower, :decimal
      add :maxLimitPower, :decimal
      add :memoryFrequency, :decimal
      add :minLimitPower, :decimal
      add :power, :decimal
      add :totalMemory, :decimal
      add :usedMemory, :decimal
      add :sc_num, :decimal

      timestamps()
    end

  end
end
