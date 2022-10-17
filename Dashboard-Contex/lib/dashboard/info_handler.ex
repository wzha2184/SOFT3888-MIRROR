defmodule Dashboard.InfoHandler do
  @moduledoc """
  Handle information get from super cluster
  """
  alias Dashboard.Database.Cpu
  alias Dashboard.Database.CpuFreq
  alias Dashboard.Database.Bmc
  alias Dashboard.Database.Gpu
  alias Dashboard.Database.ServerStatus
  alias Dashboard.Repo
  import Ecto.Query
  import Contex
  use Timex

  def get_server_status(type, sc_num, limit \\ 2) do
    q = from t in ServerStatus,
        where: t.type == ^type and t.super_cluster_number == ^sc_num,
        order_by: [desc: t.id],
        limit: ^limit,
        select: %{inserted_at: t.inserted_at, type: t.type, sc_num: t.super_cluster_number, status: t.status}
    Repo.all(q)


  end

  def get_all_server_status() do
    # get last super cluster status in database
    status_infos = get_server_status("sc", 9, 1)
    cond do
      length(status_infos) == 0 -> %{status: "N/A"}

      true ->
        [status_info] = status_infos
        {:ok, sc9_last_status} = Map.fetch(status_info, :status)

      # # IO.inspect sc9_last_status
      # sc9_status = case sc9_last_status do
      #   "error" ->
      #     "Offline"
      #   _ ->
      #     "Online"
      # end
      # IO.inspect sc9_status

      %{sc_9_status: sc9_last_status}
    end
  end

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

  def get_sc_status(limit \\ 1) do
    q = from t in Sc_status,
        order_by: [desc: t.id],
        limit: ^limit,
        select: %{inserted_at: t.inserted_at, status: t.status, info: t.info}

    status_infos = Repo.all(q)

    cond do
      length(status_infos) == 0 -> %{status: "N/A"}

      true ->
        [status_info] = status_infos
        {:ok, sc9_last_status} = Map.fetch(status_info, :status)

      # IO.inspect sc9_last_status
      sc9_status = case sc9_last_status do
        "error" ->
          "Offline"
        _ ->
          "Online"
      end

      IO.inspect sc9_status
      %{sc_9_status: sc9_status}
    end
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

  def get_gpu_info(uuid, limit \\ 10) do
    q = from t in Gpu,
        where: t.'UUID' == ^uuid,
        order_by: [desc: t.id],
        limit: ^limit,
        select: %{inserted_at: t.inserted_at, Temperature: t.'Temperature', totalMemory: t.totalMemory, freeMemory: t.freeMemory, power: t.power, uuid: t.'UUID', usedMemory: t.usedMemory, limitPower: t.limitPower, graphicsFrequency: t.graphicsFrequency, memoryFrequency: t.memoryFrequency, StreamingMultiprocessorFrequency: t.'StreamingMultiprocessorFrequency', fanSpeed: t.fanSpeed}
    Repo.all(q)
  end

  def get_gpu_charts(uuid, info_num) do
    gpu_info = get_gpu_info(uuid, info_num)
    cond do
      length(gpu_info) == 0 -> %{last_gpu_temp: "N/A", gpu_temp_svg: "gpu temp chart", gpu_free_mem_svg: "gpu free_mem_chart", gpu_power_svg: "gpu power chart"}

      true ->
      # latest information
      [last_info] = get_gpu_info(uuid, 1)
      {:ok, last_gpu_temp} = Map.fetch(last_info, :Temperature)
      {:ok, used_memory} = Map.fetch(last_info, :usedMemory)
      {:ok, power} = Map.fetch(last_info, :power)
      {:ok, limit_power} = Map.fetch(last_info, :limitPower)
      {:ok, streaming_multiprocessor_frequency} = Map.fetch(last_info, :StreamingMultiprocessorFrequency)

      #plots
      plot_options = %{
        top_margin: 5,
        right_margin: 5,
        bottom_margin: 5,
        left_margin: 5,
        show_x_axis: true,
        show_y_axis: true,
        legend_setting: :legend_right,
        mapping: %{x_col: "timestamp", y_cols: ["temp", "total_mem", "free_mem", "power", "graphics_frequency"]},
      }
      # Generate the SVG chart
      contex_dataset =
        gpu_info
        # Flatten the map into a list of lists
        |> Enum.map(fn %{inserted_at: timestamp, Temperature: temp, totalMemory: total_mem, freeMemory: free_mem, power: power, uuid: uuid, usedMemory: used_memory, limitPower: limit_power, graphicsFrequency: graphics_frequency, memoryFrequency: memory_frequency, StreamingMultiprocessorFrequency: streaming_multiprocessor_frequency, fanSpeed: fan_speed} ->
          [timestamp, Decimal.to_float(temp), Decimal.to_float(total_mem), Decimal.to_float(free_mem), Decimal.to_float(power), uuid, used_memory, limit_power, Decimal.to_float(graphics_frequency), Decimal.to_float(memory_frequency), streaming_multiprocessor_frequency, Decimal.to_float(fan_speed)]
        end)
        # Assign legend titles using list indices
        |> Contex.Dataset.new(["timestamp", "temp", "total_mem", "free_mem", "power", "uuid", "used_memory", "limit_power", "graphics_frequency", "memory_frequency", "streaming_multiprocessor_frequency", "fan_speed"])

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

        # graphicsFrequency chart
        gpu_graphics_frequency_chart =
          contex_dataset
          # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
          |> Contex.Plot.new(
            Contex.LinePlot,
            600,
            300,
            [plot_options: plot_options, title: "GPU Graphics Frequency",
            mapping: %{x_col: "timestamp", y_cols: ["graphics_frequency", "temp"]},
            x_label: "Time",
            y_label: "Frequency/Temperature"
          ]

          )
          # Generate SVG
          |> Contex.Plot.to_svg()

        # memoryFrequency chart
        gpu_memory_frequency_chart =
          contex_dataset
          # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
          |> Contex.Plot.new(
            Contex.LinePlot,
            600,
            300,
            [plot_options: plot_options, title: "GPU Memory Frequency",
            mapping: %{x_col: "timestamp", y_cols: ["memory_frequency", "temp"]},
            x_label: "Time",
            y_label: "Frequency/Temperature"
          ]


          )
          # Generate SVG
          |> Contex.Plot.to_svg()

        # fanSpeed chart
        gpu_fan_speed_chart =
          contex_dataset
          # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
          |> Contex.Plot.new(
            Contex.LinePlot,
            600,
            300,
            [plot_options: plot_options, title: "GPU Fan Speed",
            mapping: %{x_col: "timestamp", y_cols: ["fan_speed", "temp"]},
            x_label: "Time",
            y_label: "speed/Temperature"
          ]

          )
          # Generate SVG
          |> Contex.Plot.to_svg()

          %{last_streaming_multiprocessor_frequency: streaming_multiprocessor_frequency, last_limit_power: limit_power, last_power: power, last_used_memory: used_memory,last_gpu_temp: last_gpu_temp, gpu_temp_svg: gpu_temp_chart, gpu_free_mem_svg: gpu_free_mem_chart, gpu_power_svg: gpu_power_chart, gpu_graphics_frequency_chart: gpu_graphics_frequency_chart, gpu_memory_frequency_chart: gpu_memory_frequency_chart, gpu_fan_speed_chart: gpu_fan_speed_chart, uuid: uuid}
    end
  end

  def get_cpu_freq_chart(info_num) do

    cpu_freq_info = get_cpu_freq(info_num)
    cond do
      length(cpu_freq_info) == 0 -> %{last_cpu_freq: "N/A", cpu_freq_chart: "cpu frequency chart"}

      true ->
      [last_info] = get_cpu_freq(1)
      {:ok, last_cpu_freq} = Map.fetch(last_info, :cpu_current_freq)
      plot_options = %{
        top_margin: 5,
        right_margin: 5,
        bottom_margin: 5,
        left_margin: 5,
        show_x_axis: true,
        show_y_axis: true,
        legend_setting: :legend_right,
        mapping: %{x_col: "timestamp", y_cols: ["cpu_current_freq", "cpu_min_freq", "cpu_max_freq"]},
      }
      # Generate the SVG chart
      contex_dataset =
        cpu_freq_info
        # Flatten the map into a list of lists
        |> Enum.map(fn %{inserted_at: timestamp, cpu_current_freq: cpu_current_freq, cpu_min_freq: cpu_min_freq, cpu_max_freq: cpu_max_freq} ->
          [timestamp, Decimal.to_float(cpu_current_freq), Decimal.to_float(cpu_min_freq), Decimal.to_float(cpu_max_freq)]
        end)
        # Assign legend titles using list indices
        |> Contex.Dataset.new(["timestamp", "cpu_current_freq", "cpu_min_freq", "cpu_max_freq"])

      cpu_freq_chart =
        contex_dataset
        # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
        |> Contex.Plot.new(
          Contex.LinePlot,
          600,
          300,
          [plot_options: plot_options, title: "CPU Frequency",
          mapping: %{x_col: "timestamp", y_cols: ["cpu_current_freq"]},
          x_label: "Time",
          y_label: "Frequency"
        ]

        )
        # Generate SVG
        |> Contex.Plot.to_svg()


      %{last_cpu_freq: last_cpu_freq, cpu_freq_chart: cpu_freq_chart}
    end
  end

  def to_database() do
    IO.inspect("run sc script")
    # multi-thread
    pid = spawn(
      fn ->

        {_, list} = JSON.decode(Dashboard.get_super_clusters_data())

        # # sc_status table
        # changeset = Sc_status.changeset(%Sc_status{}, list["sc_status"])
        # Repo.insert(changeset)

        # # BMC table
        # changeset = Bmc.changeset(%Bmc{}, list["BMC"]["BMC1"])
        # Repo.insert(changeset)

        # sc9
        if list["CPU"]["sc9"]["status"] == "OK" do
          # CPU Freq table
          cpu_freq_sc9 = Map.put(list["CPU"]["sc9"]["cpu_freq"], "sc_num", 9)
          changeset = CpuFreq.changeset(%CpuFreq{}, cpu_freq_sc9)
          Repo.insert(changeset)

          status_info = %{} |> Map.put("type", "sc")
                            |> Map.put("super_cluster_number", 9)
                            |> Map.put("status", list["CPU"]["sc9"]["status"])
          changeset = ServerStatus.changeset(%ServerStatus{}, status_info)
          Repo.insert(changeset)
        else
          status_info = %{} |> Map.put("type", "sc")
                            |> Map.put("super_cluster_number", 9)
                            |> Map.put("status", list["CPU"]["sc9"]["status"])
          IO.inspect status_info
          changeset = ServerStatus.changeset(%ServerStatus{}, status_info)
          Repo.insert(changeset)
        end

        if list["GPU"]["sc9"]["status"] == "OK" do
          # GPU table 1
          gpu_sc9 = Map.put(list["GPU"]["sc9"]["GPU-f11c8a14-3c9b-48e8-8c02-7da2495d17ee"], "sc_num", 9)
          changeset = Gpu.changeset(%Gpu{}, gpu_sc9)
          Repo.insert(changeset)
          # IO.inspect changeset

          # GPU table 2
          gpu_sc9 = Map.put(list["GPU"]["sc9"]["GPU-5caf1987-9e67-8051-0080-9384b24a66db"], "sc_num", 9)
          changeset = Gpu.changeset(%Gpu{}, gpu_sc9)
          Repo.insert(changeset)
        end

        # sc10
        if list["CPU"]["sc10"]["status"] == "OK" do
          # CPU Freq table
          cpu_freq_sc10 = Map.put(list["CPU"]["sc10"]["cpu_freq"], "sc_num", 10)
          changeset = CpuFreq.changeset(%CpuFreq{}, cpu_freq_sc10)
          Repo.insert(changeset)

          status_info = %{} |> Map.put("type", "sc")
                            |> Map.put("super_cluster_number", 10)
                            |> Map.put("status", list["CPU"]["sc10"]["status"])
          changeset = ServerStatus.changeset(%ServerStatus{}, status_info)
          Repo.insert(changeset)
        else
          status_info = %{} |> Map.put("type", "sc")
                            |> Map.put("super_cluster_number", 10)
                            |> Map.put("status", list["CPU"]["sc10"]["status"])
          IO.inspect status_info
          changeset = ServerStatus.changeset(%ServerStatus{}, status_info)
          IO.inspect changeset
          Repo.insert(changeset)
        end

        if list["GPU"]["sc10"]["status"] == "OK" do
          # GPU table 1
          gpu_sc10 = Map.put(list["GPU"]["sc10"]["GPU-d1beb192-bcec-67d2-4a5f-51108e4f03d1"], "sc_num", 10)
          changeset = Gpu.changeset(%Gpu{}, gpu_sc10)
          Repo.insert(changeset)
          # IO.inspect changeset

          # GPU table 2
          gpu_sc10 = Map.put(list["GPU"]["sc10"]["GPU-70987dcb-d543-54bc-8ac5-fc3cfc530043"], "sc_num", 10)
          changeset = Gpu.changeset(%Gpu{}, gpu_sc10)
          Repo.insert(changeset)
        end

      end)
  end

  def getTime() do
    Timex.now() |> Timex.format!("{0M}-{0D} {h24}:{0m}:{s}") |> to_string

    # DateTime.utc_now |> to_string
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
