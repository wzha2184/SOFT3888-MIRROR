defmodule Dashboard.Repo.Migrations.CreateBmc do
  use Ecto.Migration

  def change do
    create table(:bmc) do
      add :bmc_uid, :decimal
      add :bmc_cpu_fan, :decimal
      add :bmc_cpu_opt, :decimal
      add :bmc_cpu_ecc, :string
      add :bmc_memory_train_err, :string
      add :bmc_watchdog2, :string
      add :bmc_12v, :decimal
      add :bmc_33v_alw, :decimal
      add :bmc_5v, :decimal
      add :bmc_5v_alw, :decimal
      add :bmc_cpu_18v, :decimal
      add :bmc_cpu_18v_s5, :decimal
      add :bmc_33v, :decimal
      add :bmc_pch_cldo, :decimal
      add :bmc_vcore, :decimal
      add :bmc_vddio_abcd, :decimal
      add :bmc_vddio_efgh, :decimal
      add :bmc_vsoc, :decimal
      add :bmc_chipset_fan, :decimal
      add :bmc_cpu_temp, :decimal
      add :bmc_lan_temp, :decimal
      add :bmc_soc_fan, :decimal
      add :bmc_vbat, :decimal
      timestamps()
    end

  end
end
