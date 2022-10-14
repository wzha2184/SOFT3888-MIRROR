defmodule Dashboard.Repo.Migrations.CreateScStatus do
  use Ecto.Migration

  def change do
    create table(:sc_status) do
      add :status, :string
      add :info, :string

      timestamps()
    end
  end
end
