defmodule Dashboard.Repo.Migrations.CreateGpu do
  use Ecto.Migration

  def change do
    create table(:gpu) do
      add :gpu_uuid, :decimal
      add :gpu_bios, :decimal
      add :gpu_name, :string
      add :gpu_temperature, :decimal
      add :gpu_fan_speed, :decimal
      add :gpu_total_memory, :decimal
      add :gpu_used_memory, :decimal
      add :gpu_free_memory, :decimal
      add :gpu_power, :decimal
      add :gpu_limit_power, :decimal
      add :gpu_min_limit_power, :decimal
      add :gpu_max_limit_power, :decimal
      add :gpu_steaming_multi_processer_freq, :decimal
      add :gpu_max_steaming_multi_processer_freq, :decimal
      add :gpu_memory_freq, :decimal
      add :gpu_max_memory_freq, :decimal
      add :gpu_freq, :decimal
      add :gpu_max_freq, :decimal
      add :gpu_min_freq, :decimal
      timestamps()
    end

  end
end
