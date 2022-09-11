defmodule Dbmonitor.Repo.Migrations.CreateGpu do
  use Ecto.Migration

  def change do
    create table(:gpuinfo) do
      add :gpuuid, :binary_id, null: false
      add :serialnum, :string, default: "N/A"
      add :temperature, :integer
      add :fanspeed, :integer
      add :watts, :integer
      add :timestamp, :naive_datetime
    end
  end
end
