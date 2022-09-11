defmodule Dashboard.Repo.Migrations.CreateCpu do
  use Ecto.Migration

  def change do

    create table(:cpu) do
      add :cpu_temperature, :decimal
      add :cpu_fan_speed, :decimal
      add :cpu_voltage, :decimal
      add :cpu_current_freq, :decimal
      add :cpu_max_freq, :decimal
      add :cpu_min_freq, :decimal
      timestamps()
    end


  end
end
