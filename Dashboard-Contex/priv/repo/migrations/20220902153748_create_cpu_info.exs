defmodule Dashboard.Repo.Migrations.CreateCpuInfo do
  use Ecto.Migration

  def change do
    create table(:cpu_info) do
      add :CPU_FAN, :string
      add :CPU_OPT, :string
      add :CPU_ECC, :string
      add :Memory_Train_ERR, :string
      add :Watchdog2, :string
      add :sc_num, :decimal

      # timestamps(autogenerate: {MyThing, :local_time, []})
      timestamps()
    end
  end

  def local_time do
    DateTime.now!("Australia/Sydney") |> DateTime.to_naive()
  end
end
