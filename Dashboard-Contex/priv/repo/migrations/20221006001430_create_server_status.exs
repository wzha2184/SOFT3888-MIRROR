defmodule Dashboard.Repo.Migrations.CreateServerStatus do
  use Ecto.Migration

  def change do
    create table(:server_status) do
      add :type, :string
      add :super_cluster_number, :decimal
      add :status, :string

      # timestamps(autogenerate: {MyThing, :local_time, []})
      timestamps()
    end
  end

  def local_time do
    DateTime.now!("Australia/Sydney") |> DateTime.to_naive()
  end
end
