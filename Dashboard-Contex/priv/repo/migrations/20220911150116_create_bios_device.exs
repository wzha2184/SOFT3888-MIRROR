defmodule Dashboard.Repo.Migrations.CreateBiosDevice do
  use Ecto.Migration

  def change do
    create table(:bios_device) do
      add :bios_serial_number, :numeric
      add :bios_device_number, :decimal
      add :bios_device_type, :text
      add :bios_device_status, :text
      add :bios_device_description, :text
      add :sc_num, :decimal

      # timestamps(autogenerate: {MyThing, :local_time, []})
      timestamps()
    end
  end

  def local_time do
    DateTime.now!("Australia/Sydney") |> DateTime.to_naive()
  end
end
