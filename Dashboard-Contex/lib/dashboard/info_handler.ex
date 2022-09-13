defmodule Dashboard.InfoHandler do
  @moduledoc """
  Handle information get from super cluster
  """
  alias Dashboard.Database.Cpu
  alias Dashboard.Database.CpuFreq
  alias Dashboard.Database.Bmc
  alias Dashboard.Database.Gpu
  alias Dashboard.Repo
  import Ecto.Query
  import Contex

  def get_cpu_freq(limit \\ 10) do
    q = from f in CpuFreq,
        order_by: [desc: f.id],
        limit: ^limit,
        select: %{inserted_at: f.inserted_at, cpu_current_freq: f.cpu_current_freq, cpu_max_freq: f.cpu_max_freq, cpu_min_freq: f.cpu_min_freq}

    Repo.all(q)
    # [
    #   %Dashboard.Database.CpuFreq{
    #     __meta__: #Ecto.Schema.Metadata<:loaded, "cpu_freq">,
    #     cpu_current_freq: #Decimal<3772.77541757>,
    #     cpu_max_freq: #Decimal<3900>,
    #     cpu_min_freq: #Decimal<2200>,
    #     id: 81,
    #     inserted_at: ~N[2022-09-08 04:23:09],
    #     updated_at: ~N[2022-09-08 04:23:09]
    #   }
    # ]

  end

  def get_bmc_info(limit \\ 10) do
    q = from t in Bmc,
        order_by: [desc: t.id],
        limit: ^limit,
        select: %{inserted_at: t.inserted_at, cpu_temp: t.bmc_cpu_temp, lan_temp: t.bmc_lan_temp, bmc_chipset_fan: t.bmc_chipset_fan}

    Repo.all(q)
  end

  def get_bmc_charts(info_num) do
    bmc_info = get_bmc_info(info_num)
    [head | tail] = bmc_info
    # IO.inspect Map.fetch(head, :cpu_temp)
    {:ok, last_cpu_temp} = case length(bmc_info) do
      1 -> {:ok, "N/A"}
      _ -> Map.fetch(head, :cpu_temp)
    end

    plot_options = %{
      top_margin: 5,
      right_margin: 5,
      bottom_margin: 5,
      left_margin: 5,
      show_x_axis: true,
      show_y_axis: true,
      title: "CPU Temp",
      x_label: "Time",
      legend_setting: :legend_right,
      mapping: %{x_col: "timestamp", y_cols: ["cpu_temp", "lan_temp", "bmc_chipset_fan"]},
    }
    # Generate the SVG chart
    contex_dataset =
      bmc_info
      # Flatten the map into a list of lists
      |> Enum.map(fn %{inserted_at: timestamp, cpu_temp: bmc_cpu_temp, lan_temp: bmc_lan_temp, bmc_chipset_fan: bmc_chipset_fan} ->
        [timestamp, Decimal.to_float(bmc_cpu_temp), Decimal.to_float(bmc_lan_temp), Decimal.to_float(bmc_chipset_fan)]
      end)
      # Assign legend titles using list indices
      |> Contex.Dataset.new(["timestamp", "bmc_cpu_temp", "bmc_lan_temp", "bmc_chipset_fan"])

    bmc_cpu_temp_chart =
      contex_dataset
      # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
      |> Contex.Plot.new(
        Contex.LinePlot,
        600,
        300,
        [plot_options: plot_options, title: "CPU Temperature",
        mapping: %{x_col: "timestamp", y_cols: ["bmc_cpu_temp"]},
        x_label: "Time",
        y_label: "Temperature"
      ]

      )
      # Generate SVG
      |> Contex.Plot.to_svg()

    bmc_lan_temp_chart =
      contex_dataset
      # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
      |> Contex.Plot.new(
        Contex.LinePlot,
        600,
        300,
        [plot_options: plot_options, title: "Lan Temperature",
        mapping: %{x_col: "timestamp", y_cols: ["bmc_lan_temp"]},
        x_label: "Time",
        y_label: "Temperature"
      ]
      )
      # Generate SVG
      |> Contex.Plot.to_svg()

    bmc_chipset_fan_chart =
      contex_dataset
      # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
      |> Contex.Plot.new(
        Contex.LinePlot,
        600,
        300,
        [plot_options: plot_options, title: "Chipset Fan",
        mapping: %{x_col: "timestamp", y_cols: ["bmc_chipset_fan"]},
        x_label: "Time",
        y_label: "Fan Speed"
      ]
      )
      # Generate SVG
      |> Contex.Plot.to_svg()

    [bmc_cpu_temp_chart, bmc_lan_temp_chart, bmc_chipset_fan_chart]
  end

  def get_gpu_info(limit \\ 10) do
    q = from t in Gpu,
        order_by: [desc: t.id],
        limit: ^limit,
        select: %{inserted_at: t.inserted_at, Temperature: t.'Temperature', totalMemory: t.totalMemory, freeMemory: t.freeMemory, power: t.power}

    Repo.all(q)
  end

  def get_gpu_charts(info_num) do
    gpu_info = get_gpu_info(info_num)
    cond do
      length(gpu_info) == 0 -> ["gpu_temp_chart", "gpu_free_mem_chart", "gpu_power_chart"]
      true ->
      plot_options = %{
        top_margin: 5,
        right_margin: 5,
        bottom_margin: 5,
        left_margin: 5,
        show_x_axis: true,
        show_y_axis: true,
        legend_setting: :legend_right,
        mapping: %{x_col: "timestamp", y_cols: ["temp", "total_mem", "free_mem", "power"]},
      }
      # Generate the SVG chart
      contex_dataset =
        gpu_info
        # Flatten the map into a list of lists
        |> Enum.map(fn %{inserted_at: timestamp, Temperature: temp, totalMemory: total_mem, freeMemory: free_mem, power: power} ->
          [timestamp, Decimal.to_float(temp), Decimal.to_float(total_mem), Decimal.to_float(free_mem), Decimal.to_float(power)]
        end)
        # Assign legend titles using list indices
        |> Contex.Dataset.new(["timestamp", "temp", "total_mem", "free_mem", "power"])

      gpu_temp_chart =
        contex_dataset
        # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
        |> Contex.Plot.new(
          Contex.LinePlot,
          600,
          300,
          [plot_options: plot_options, title: "GPU Temperature",
          mapping: %{x_col: "timestamp", y_cols: ["temp"]},
          x_label: "Time",
          y_label: "Temperature"
        ]

        )
        # Generate SVG
        |> Contex.Plot.to_svg()

        gpu_free_mem_chart =
          contex_dataset
          # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
          |> Contex.Plot.new(
            Contex.LinePlot,
            600,
            300,
            [plot_options: plot_options, title: "GPU Free Memory",
            mapping: %{x_col: "timestamp", y_cols: ["free_mem"]},
            x_label: "Time",
            y_label: "Free Memory"
          ]

          )
          # Generate SVG
          |> Contex.Plot.to_svg()

        gpu_power_chart =
          contex_dataset
          # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
          |> Contex.Plot.new(
            Contex.LinePlot,
            600,
            300,
            [plot_options: plot_options, title: "GPU Power",
            mapping: %{x_col: "timestamp", y_cols: ["power"]},
            x_label: "Time",
            y_label: "Power"
          ]

          )
          # Generate SVG
          |> Contex.Plot.to_svg()

        [gpu_temp_chart, gpu_free_mem_chart, gpu_power_chart]
    end
  end

  def get_cpu_chart(info_num) do
    cpu_freq = get_cpu_freq(info_num)
    plot_options = %{
      top_margin: 5,
      right_margin: 5,
      bottom_margin: 5,
      left_margin: 5,
      show_x_axis: true,
      show_y_axis: true,
      title: "CPU Freq",
      x_label: "Time",
      legend_setting: :legend_right,
      mapping: %{x_col: "timestamp", y_cols: ["cpu_current_freq", "cpu_min_freq", "cpu_max_freq"]},
    }
    # Generate the SVG chart
    cpu_chart =
      cpu_freq
      # Flatten the map into a list of lists
      |> Enum.map(fn %{inserted_at: timestamp, cpu_current_freq: cpu_current_freq, cpu_min_freq: cpu_min_freq, cpu_max_freq: cpu_max_freq} ->
        [timestamp, Decimal.to_float(cpu_current_freq), Decimal.to_float(cpu_min_freq), Decimal.to_float(cpu_max_freq)]
      end)


      # [[3772.77, 3900, 2200, ~N[2022-09-08 04:23:09]], [3772.77, 3900, 2200, ~N[2022-09-08 04:24:09]]]
      # Assign legend titles using list indices
      |> Contex.Dataset.new(["timestamp", "cpu_current_freq", "cpu_min_freq", "cpu_max_freq"])
      # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
      |> Contex.Plot.new(
        Contex.LinePlot,
        600,
        300,
        [plot_options: plot_options, title: "CPU Freq",
        mapping: %{x_col: "timestamp", y_cols: ["cpu_current_freq"]},
        x_label: "Time",
      ]

      )
      # Generate SVG
      |> Contex.Plot.to_svg()

      # |> Contex.LinePlot.new(
      #   mapping: %{x_col: "timestamp", y_cols: ["cpu_current_freq", "cpu_min_freq", "cpu_max_freq"]},
      #   plot_options: plot_options,
      #   title: "CPU Freq",
      #   x_label: "Time",
      #   legend_setting: :legend_right
      # )
      # |>Contex.Plot.to_svg()

    cpu_chart
  end

  def to_database() do
    # multi-thread
    pid = spawn(
      fn ->

        {_, list} = JSON.decode(Dashboard.get_super_clusters_data())
        # BMC table
        changeset = Bmc.changeset(%Bmc{}, list["BMC"]["BMC1"])
        Repo.insert(changeset)

        # GPU table
        changeset = Gpu.changeset(%Gpu{}, list["GPU"]["GPU-f11c8a14-3c9b-48e8-8c02-7da2495d17ee"])
        Repo.insert(changeset)

        # IO.inspect changeset

      end)
  end

  def time() do
    DateTime.utc_now |> to_string
  end

  def uptime() do
    {uptime, _} = :erlang.statistics(:wall_clock)
    uptime
  end

  def available_core() do
    :erlang.system_info(:logical_processors_online)

  end

  def get_memory() do
    :erlang.memory(:total)
  end

end
