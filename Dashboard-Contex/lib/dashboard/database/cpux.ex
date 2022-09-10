defmodule Dashboard.Database.Cpu do
  use Ecto.Schema
  import Ecto.Changeset
  # alias Dashboard.Database.Cpu

# {
#   "critical_sensors": {
#     "CPU_FAN": "1000RPM",
#     "CPU_OPT": "1300RPM"
#   },
#   "descrete_sensors": {
#     "CPU_ECC": "Presence Detected",
#     "Memory_Train_ERR": "N/A",
#     "Watchdog2": "N/A"
#   },
#   "normal_sensors": {
#     "+12V": "12.120 Volts",
#     "+3.3V": "3.328 Volts",
#     "+3.3V_ALW": "3.312 Volts",
#     "+5V": "5.064 Volts",
#     "+5V_ALW": "5.016 Volts",
#     "+CPU_1.8V": "1.770 Volts",
#     "+CPU_1.8V_S5": "1.810 Volts",
#     "+CPU_3.3V": "3.424 Volts",
#     "+PCH_CLDO": "1.182 Volts",
#     "+VCORE": "1.384 Volts",
#     "+VDDIO_ABCD": "1.230 Volts",
#     "+VDDIO_EFGH": "1.230 Volts",
#     "+VSOC": "1.044 Volts",
#     "CHIPSET_FAN": "1700 RPM",
#     "CPU Temp.": "56 \u00b0C",
#     "LAN Temp.": "57 \u00b0C",
#     "SOC_FAN": "2400 RPM",
#     "VBAT": "3.280 Volts"
#   },
#   "cpu_freq": {
#     "cpu_current_freq": 2252.99321875,
#     "cpu_min_freq": 2200.0,
#     "cpu_max_freq": 3900.0
#   },
#   "baseboard-serial-number": "210686206000109",
#   "On Board Devices": {
#     "Device 1": {
#       "Type": "Video",
#       "Status": "Enabled",
#       "Description": "   To Be Filled By O.E.M."
#     }
#   },
#   "PCIe information": {
#     "System Slot  1": {
#       "Designation": "PCIEX16_1",
#       "Type": "x16 PCI Express",
#       "Current Usage": "In Use",
#       "Length": "Long",
#       "ID": "0",
#       "Characteristics": "3.3 V is provided, Opening is shared, PME signal is supported",
#       "Bus Address": "0000:00:00.0"
#     },
#     "System Slot  2": {
#       "Designation": "PCIEX16_2",
#       "Type": "x8 PCI Express",
#       "Current Usage": "In Use",
#       "Length": "Long",
#       "ID": "1",
#       "Characteristics": "3.3 V is provided, Opening is shared, PME signal is supported",
#       "Bus Address": "0000:00:00.0"
#     },
#     "System Slot  3": {
#       "Designation": "PCIEX16_3",
#       "Type": "x16 PCI Express",
#       "Current Usage": "In Use",
#       "Length": "Long",
#       "ID": "2",
#       "Characteristics": "3.3 V is provided, Opening is shared, PME signal is supported",
#       "Bus Address": "0000:00:00.0"
#     },
#     "System Slot 4": {
#       "Designation": "PCIEX16_4",
#       "Type": "x8 PCI Express",
#       "Current Usage": "In Use",
#       "Length": "Long",
#       "ID": "3",
#       "Characteristics": "3.3 V is provided, Opening is shared, PME signal is supported",
#       "Bus Address": "0000:00:00.0"
#     }
#   }
# }

  schema "cpu_info" do

    field :CPU_FAN, :string
    field :CPU_OPT, :string
    field :CPU_ECC, :string
    field :Memory_Train_ERR, :string
    field :Watchdog2, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:CPU_FAN, :CPU_OPT, :CPU_ECC, :Memory_Train_ERR, :Watchdog2])
    # |> validate_required([:name, :email, :bio, :number_of_pets])
  end
end
