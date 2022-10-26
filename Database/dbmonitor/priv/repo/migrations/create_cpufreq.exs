defmodule Dbmonitor.Repo.Migrations.CreateCpuFreq do
  use Ecto.Migration

  def change do
    create table(:cpu_freq) do
      add :cpu_current_freq, :float, null: false
      add :cpu_min_freq, :float, default: 0.0
      add :cpu_max_freq, :float, default: 0.0
    end
  end
end
