defmodule Dbmonitor.Repo.Migrations.CreateCriticalsens do
  use Ecto.Migration

  def change do
    create table(:criticalsens) do
      add :cpufan, :string, null: false
      add :cpuopt, :string, default: "0"
    end
  end
end
