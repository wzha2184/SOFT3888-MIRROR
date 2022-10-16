defmodule Dashboard.Repo.Migrations.CreateCpu do
  use Ecto.Migration

  def change do

    create table(:cpu) do
      add :cpu_serial_number, :decimal
      add :cpu_temperature, :decimal
      add :cpu_fan_speed, :decimal
      add :cpu_voltage, :decimal
      add :cpu_current_freq, :decimal
      add :cpu_max_freq, :decimal
      add :cpu_min_freq, :decimal
      add :sc_num, :decimal

      # timestamps(autogenerate: {MyThing, :local_time, []})
      timestamps()
    end
  end

  def local_time do
    DateTime.now!("Australia/Sydney") |> DateTime.to_naive()
  end
end
