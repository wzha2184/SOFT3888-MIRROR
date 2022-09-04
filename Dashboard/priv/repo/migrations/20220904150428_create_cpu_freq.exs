defmodule Dashboard.Repo.Migrations.CreateCpuFreq do
  use Ecto.Migration

  def change do
    create table(:cpu_freq) do
      add :cpu_current_freq, :decimal
      add :cpu_min_freq, :decimal
      add :cpu_max_freq, :decimal

      timestamps()
    end
  end
end
