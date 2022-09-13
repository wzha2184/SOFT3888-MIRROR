defmodule Dashboard.Repo.Migrations.CreateBiosPcie do
  use Ecto.Migration

  def change do
    create table(:bios_pcie) do
      add :bios_serial_number, :numeric
      add :bios_pcie_slot_number, :decimal
      add :bios_pcie_designation, :text
      add :bios_pcie_current_usage, :text
      add :bios_pcie_length, :text
      add :bios_pcie_id, :decimal
      add :bios_pcie_characteristics, :text
      add :bios_pcie_bus_address, :text
      timestamps()

    end

  end
end
