defmodule Dashboard.Database.Bmc do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bmc" do
    field :bmc_uid, :decimal
    field :bmc_cpu_fan, :decimal
    field :bmc_cpu_opt, :decimal
    field :bmc_cpu_ecc, :string
    field :bmc_memory_train_err, :string
    field :bmc_watchdog2, :string
    field :bmc_12v, :decimal
    field :bmc_33v_alw, :decimal
    field :bmc_5v, :decimal
    field :bmc_5v_alw, :decimal
    field :bmc_cpu_18v, :decimal
    field :bmc_cpu_18v_s5, :decimal
    field :bmc_33v, :decimal
    field :bmc_pch_cldo, :decimal
    field :bmc_vcore, :decimal
    field :bmc_vddio_abcd, :decimal
    field :bmc_vddio_efgh, :decimal
    field :bmc_vsoc, :decimal
    field :bmc_chipset_fan, :decimal
    field :bmc_cpu_temp, :decimal
    field :bmc_lan_temp, :decimal
    field :bmc_soc_fan, :decimal
    field :bmc_vbat, :decimal
    field :sc_num, :decimal

    timestamps()
  end

  @doc false
  def changeset(bmc, attrs) do
    bmc
    |> cast(attrs, [:bmc_12v, :bmc_33v, :bmc_33v_alw, :bmc_5v, :bmc_5v_alw, :bmc_cpu_18v, :bmc_cpu_18v_s5,
    :bmc_pch_cldo, :bmc_vcore, :bmc_vddio_abcd, :bmc_vddio_efgh, :bmc_vsoc, :bmc_chipset_fan,
    :bmc_cpu_temp, :bmc_cpu_ecc, :bmc_cpu_fan, :bmc_cpu_opt, :bmc_lan_temp, :bmc_memory_train_err,
    :bmc_soc_fan, :bmc_vbat, :bmc_watchdog2, :sc_num])
    |> validate_required([:bmc_12v, :bmc_33v, :bmc_33v_alw, :bmc_5v, :bmc_5v_alw, :bmc_cpu_18v, :bmc_cpu_18v_s5,
    :bmc_pch_cldo, :bmc_vcore, :bmc_vddio_abcd, :bmc_vddio_efgh, :bmc_vsoc, :bmc_chipset_fan,
    :bmc_cpu_temp, :bmc_cpu_ecc, :bmc_cpu_fan, :bmc_cpu_opt, :bmc_lan_temp, :bmc_memory_train_err,
    :bmc_soc_fan, :bmc_vbat, :bmc_watchdog2, :sc_num])

    # |> cast(attrs, [:bmc_12v, :bmc_33v, :bmc_33v_alw, :bmc_5v, :bmc_5v_alw, :bmc_cpu_18v, :bmc_cpu_18v_s5,
    # :bmc_33v, :bmc_pch_cldo, :bmc_vcore, :bmc_vddio_abcd, :bmc_vddio_efgh, :bmc_vcore, :bmc_chipset_fan,
    # :bmc_cpu_temp, :bmc_cpu_ecc, :bmc_cpu_fan, :bmc_cpu_opt, :bmc_lan_temp, :bmc_memory_train_err,
    # :bmc_soc_fan, :bmc_vbat, :bmc_watchdog2])

  end
end
