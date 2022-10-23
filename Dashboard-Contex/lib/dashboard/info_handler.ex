defmodule Dashboard.InfoHandler do
  @moduledoc """
  Handle information get from super cluster
  """
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
        where: t.type == ^type and t.sc_num == ^sc_num,
        order_by: [desc: t.id],
        limit: ^limit,
        select: %{inserted_at: t.inserted_at, type: t.type, sc_num: t.sc_num, status: t.status}
    Repo.all(q)


  end

  def get_all_server_status(type, sc_list) do
    Enum.reduce sc_list, %{}, fn sc_name, acc ->
      server_info = get_server_status(type, sc_name, 2)

      if_update = cond do
        length(server_info) == 0 ->
          "false_" <> "N/A"
        length(server_info) == 1 ->
          [info] = server_info
          {:ok, status} = Map.fetch(info, :status)
          "true_" <> status

        true ->
        # latest information
        [info1, info2] = server_info
        # info1 == info2
        {:ok, status} = Map.fetch(info1, :status)
        {:ok, status_2} = Map.fetch(info2, :status)

        to_string(status != status_2) <> "_" <> status

      end
      Map.put(acc, sc_name, if_update)

    end

  end

  def get_gpu_info(sc_num, gpu_id, limit \\ 10) do
    q = from t in Gpu,
        where: t.gpu_id == ^gpu_id and t.sc_num == ^sc_num,
        order_by: [desc: t.id],
        limit: ^limit,
        select: %{inserted_at: t.inserted_at, Temperature: t.'Temperature', totalMemory: t.totalMemory, freeMemory: t.freeMemory, power: t.power, uuid: t.'UUID', usedMemory: t.usedMemory, limitPower: t.limitPower, graphicsFrequency: t.graphicsFrequency, memoryFrequency: t.memoryFrequency, StreamingMultiprocessorFrequency: t.'StreamingMultiprocessorFrequency', fanSpeed: t.fanSpeed}
    Repo.all(q)
  end

  def get_gpu_infos(sc_num, gpu_id, info_num) do
    gpu_info = get_gpu_info(sc_num, gpu_id, info_num)
    cond do
      length(gpu_info) == 0 -> %{last_streaming_multiprocessor_frequency: "N/A", last_limit_power: "N/A", last_power: "N/A", last_used_memory: "N/A",last_gpu_temp: "N/A", gpu_temp_svg: "Gpu Temperature Chart", gpu_free_mem_svg: "Gpu Free Memory Chart", gpu_power_svg: "Gpu Power Chart", gpu_graphics_frequency_chart: "Gpu Graphics Frequency Chart", gpu_memory_frequency_chart: "Gpu Memory Frequency Chart", gpu_fan_speed_chart: "Gpu Fan Speed Chart", uuid: "N/A"}

      true ->
      # latest information
      [last_info] = get_gpu_info(sc_num, gpu_id, 1)
      {:ok, uuid} = Map.fetch(last_info, :uuid)
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


  def get_cpu_freq(sc_num, limit \\ 10) do
    q = from t in CpuFreq,
        where: t.sc_num == ^sc_num,
        order_by: [desc: t.id],
        limit: ^limit,
        select: %{inserted_at: t.inserted_at, cpu_current_freq: t.cpu_current_freq, cpu_max_freq: t.cpu_max_freq, cpu_min_freq: t.cpu_min_freq, gpu_count: t.gpu_count}
    Repo.all(q)
  end

  def get_cpu_freq_infos(sc_num, info_num) do
    cpu_freq_info = get_cpu_freq(sc_num, info_num)
    # IO.inspect cpu_freq_info
    cond do
      length(cpu_freq_info) == 0 -> %{cpu_current_freq: "N/A", cpu_min_freq: "N/A", cpu_max_freq: "N/A", cpu_freq_chart: "Cpu Frequency Chart"}

      true ->
      # latest information
      [last_info] = get_cpu_freq(sc_num, 1)
      {:ok, cpu_current_freq} = Map.fetch(last_info, :cpu_current_freq)
      {:ok, cpu_min_freq} = Map.fetch(last_info, :cpu_min_freq)
      {:ok, cpu_max_freq} = Map.fetch(last_info, :cpu_max_freq)

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

      %{cpu_current_freq: cpu_current_freq, cpu_min_freq: cpu_min_freq, cpu_max_freq: cpu_max_freq, cpu_freq_chart: cpu_freq_chart}
    end
  end


  def get_bmc_info(sc_num, limit \\ 10) do
    q = from t in Bmc,
        where: t.sc_num == ^sc_num,
        order_by: [desc: t.id],
        limit: ^limit,
        select: %{inserted_at: t.inserted_at, bmc_cpu_fan: t.bmc_cpu_fan,
        bmc_12v: t.bmc_12v, bmc_33v: t.bmc_33v,
        bmc_5v: t.bmc_5v, bmc_cpu_18v: t.bmc_cpu_18v, bmc_cpu_33v: t.bmc_cpu_33v,
        bmc_pch_cldo: t.bmc_pch_cldo, bmc_vcore: t.bmc_vcore,
        bmc_chipset_fan: t.bmc_chipset_fan, bmc_cpu_temp: t.bmc_cpu_temp, bmc_vbat: t.bmc_vbat}#bmc_cpu_opt: t.bmc_cpu_opt,
    Repo.all(q)
  end

  def get_bmc_infos(sc_num, info_num) do
    bmc_info = get_bmc_info(sc_num, info_num)
    # IO.inspect cpu_freq_info
    cond do
      length(bmc_info) == 0 -> %{}

      true ->
      # latest information
      [last_info] = get_bmc_info(sc_num, 1)
      # {:ok, bmc_cpu_opt} = Map.fetch(last_info, :bmc_cpu_opt)
      {:ok, bmc_cpu_fan} = Map.fetch(last_info, :bmc_cpu_fan)
      {:ok, bmc_12v} = Map.fetch(last_info, :bmc_12v)
      {:ok, bmc_33v} = Map.fetch(last_info, :bmc_33v)
      {:ok, bmc_5v} = Map.fetch(last_info, :bmc_5v)
      {:ok, bmc_cpu_18v} = Map.fetch(last_info, :bmc_cpu_18v)
      {:ok, bmc_cpu_33v} = Map.fetch(last_info, :bmc_cpu_33v)
      {:ok, bmc_pch_cldo} = Map.fetch(last_info, :bmc_pch_cldo)
      {:ok, bmc_vcore} = Map.fetch(last_info, :bmc_vcore)
      {:ok, bmc_chipset_fan} = Map.fetch(last_info, :bmc_chipset_fan)
      {:ok, bmc_cpu_temp} = Map.fetch(last_info, :bmc_cpu_temp)
      {:ok, bmc_vbat} = Map.fetch(last_info, :bmc_vbat)
      {:ok, time} = Map.fetch(last_info, :inserted_at)


      plot_options = %{
        top_margin: 5,
        right_margin: 5,
        bottom_margin: 5,
        left_margin: 5,
        show_x_axis: true,
        show_y_axis: true,
        legend_setting: :legend_right,
        # mapping: %{x_col: "timestamp", y_cols: ["cpu_current_freq", "cpu_min_freq", "cpu_max_freq"]},
      }
      # Generate the SVG chart
      contex_dataset =
        bmc_info
        # Flatten the map into a list of lists
        |> Enum.map(fn %{inserted_at: timestamp, bmc_cpu_fan: bmc_cpu_fan, bmc_12v: bmc_12v, bmc_33v: bmc_33v,
        bmc_5v: bmc_5v, bmc_cpu_18v: bmc_cpu_18v, bmc_cpu_33v: bmc_cpu_33v, bmc_pch_cldo: bmc_pch_cldo,
        bmc_vcore: bmc_vcore, bmc_chipset_fan: bmc_chipset_fan, bmc_cpu_temp: bmc_cpu_temp, bmc_vbat: bmc_vbat} ->
          [timestamp, Decimal.to_float(bmc_cpu_fan), Decimal.to_float(bmc_12v), Decimal.to_float(bmc_33v),
          Decimal.to_float(bmc_5v), Decimal.to_float(bmc_cpu_18v), Decimal.to_float(bmc_cpu_33v),
          Decimal.to_float(bmc_pch_cldo), Decimal.to_float(bmc_vcore), Decimal.to_float(bmc_chipset_fan),
          Decimal.to_float(bmc_cpu_temp), Decimal.to_float(bmc_vbat)] #bmc_cpu_opt: bmc_cpu_opt,
        end)
        # Assign legend titles using list indices
        |> Contex.Dataset.new(["timestamp", "bmc_cpu_fan", "bmc_12v", "bmc_33v",
        "bmc_5v", "bmc_cpu_18v", "bmc_cpu_33v", "bmc_pch_cldo", "bmc_vcore", "bmc_chipset_fan",
        "bmc_cpu_temp", "bmc_vbat"])

      cpu_fan_chart =
        contex_dataset
        # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
        |> Contex.Plot.new(
          Contex.LinePlot,
          600,
          300,
          [plot_options: plot_options, title: "CPU Fan & Temperature",
          mapping: %{x_col: "timestamp", y_cols: ["bmc_cpu_fan", "bmc_cpu_temp"]},
          x_label: "Time",
          y_label: "Fan Frequency/Temperature"
         ]

        )
        # Generate SVG
        |> Contex.Plot.to_svg()

      bmc_12v_chart =
        contex_dataset
        # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
        |> Contex.Plot.new(
          Contex.LinePlot,
          600,
          300,
          [plot_options: plot_options, title: "+12V",
          mapping: %{x_col: "timestamp", y_cols: ["bmc_12v"]},
          x_label: "Time",
          y_label: "+12V"
          ]

        )
        # Generate SVG
        |> Contex.Plot.to_svg()

      vcore_chart =
        contex_dataset
        # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
        |> Contex.Plot.new(
          Contex.LinePlot,
          600,
          300,
          [plot_options: plot_options, title: "+VCORE",
          mapping: %{x_col: "timestamp", y_cols: ["bmc_vcore"]},
          x_label: "Time",
          y_label: "+VCORE"
          ]

        )
        # Generate SVG
        |> Contex.Plot.to_svg()

      cpu_temp_chart =
        contex_dataset
        # Specify plot type (LinePlot), SVG dimensions, column mapping, title, label and legend
        |> Contex.Plot.new(
          Contex.LinePlot,
          600,
          300,
          [plot_options: plot_options, title: "CPU Temperature",
          mapping: %{x_col: "timestamp", y_cols: ["bmc_cpu_temp"]},
          x_label: "Time",
          y_label: "CPU Temperature"
          ]

        )
        # Generate SVG
        |> Contex.Plot.to_svg()

      %{bmc_cpu_fan: bmc_cpu_fan, bmc_12v: bmc_12v, bmc_33v: bmc_33v,
      bmc_5v: bmc_5v, bmc_cpu_18v: bmc_cpu_18v, bmc_cpu_33v: bmc_cpu_33v, bmc_pch_cldo: bmc_pch_cldo,
      bmc_vcore: bmc_vcore, bmc_chipset_fan: bmc_chipset_fan, bmc_cpu_temp: bmc_cpu_temp, bmc_vbat: bmc_vbat,
      cpu_temp_chart: cpu_temp_chart, vcore_chart: vcore_chart, bmc_12v_chart: bmc_12v_chart, cpu_fan_chart: cpu_fan_chart, time: time}
    end
  end


  def call_sc_script() do
    IO.inspect("run sc script")
    # multi-thread
    _pid = spawn(
      fn ->
        {_, list} = JSON.decode(Dashboard.get_super_clusters_data())
        sc_list = get_sc_config_list()
        Enum.each(sc_list, fn(s) -> sc_store_to_db(list, s) end)

      end)
  end

  def sc_store_to_db(list, sc_name) do
    # Check
    if list["CPU"][sc_name]["status"] == "OK" do
      gpu_num = if list["GPU"][sc_name]["status"] == "OK" do
        gpu_num = list["GPU"][sc_name]["GPU_count"]
      else
        gpu_num = 0
      end
      # CPU Freq table
      cpu_freq = Map.put(list["CPU"][sc_name]["cpu_freq"], "sc_num", sc_name)
      |> Map.put("gpu_count", gpu_num)

      changeset = CpuFreq.changeset(%CpuFreq{}, cpu_freq)
      Repo.insert(changeset)

      status_info = %{} |> Map.put("type", "sc")
                        |> Map.put("sc_num", sc_name)
                        |> Map.put("status", list["CPU"][sc_name]["status"])
      changeset = ServerStatus.changeset(%ServerStatus{}, status_info)
      Repo.insert(changeset)
    else
      status_info = %{} |> Map.put("type", "sc")
                        |> Map.put("sc_num", sc_name)
                        |> Map.put("status", list["CPU"][sc_name]["status"])
      IO.inspect status_info
      changeset = ServerStatus.changeset(%ServerStatus{}, status_info)
      Repo.insert(changeset)
    end

    if list["GPU"][sc_name]["status"] == "OK" do
      gpu_num = list["GPU"][sc_name]["GPU_count"]
      for n <- 1..gpu_num do
        # GPU table
        gpu_sc = Map.put(list["GPU"][sc_name][to_string(n)], "sc_num", sc_name)
        |> Map.put("gpu_id", to_string(n))

        changeset = Gpu.changeset(%Gpu{}, gpu_sc)
        Repo.insert(changeset)
        # IO.inspect changeset
      end
    end
  end

  def call_bmc_script() do
    IO.inspect("run bmc script")
    # multi-thread
    _pid = spawn(
      fn ->
        {_, list} = JSON.decode(Dashboard.get_bmc_data())
        sc_list = get_sc_config_list()
        Enum.each(sc_list, fn(s) -> bmc_store_to_db(list, s) end)

      end)
  end

  def bmc_store_to_db(list, sc_name) do

    # bmc table
    if list["BMC"][sc_name]["status"] == "OK" do

      bmc_info = Map.put(list["BMC"][sc_name], "sc_num", sc_name)


      changeset = Bmc.changeset(%Bmc{}, bmc_info)
      Repo.insert(changeset)

      status_info = %{} |> Map.put("type", "bmc")
                        |> Map.put("sc_num", sc_name)
                        |> Map.put("status", list["BMC"][sc_name]["status"])
      changeset = ServerStatus.changeset(%ServerStatus{}, status_info)
      Repo.insert(changeset)
    else
      status_info = %{} |> Map.put("type", "bmc")
                        |> Map.put("sc_num", sc_name)
                        |> Map.put("status", list["BMC"][sc_name]["status"])
      IO.inspect status_info
      changeset = ServerStatus.changeset(%ServerStatus{}, status_info)
      Repo.insert(changeset)
    end

  end



  def getTime() do
    Timex.now("Australia/Sydney") |> Timex.format!("{0M}-{0D} {h24}:{0m}:{s}") |> to_string

    # DateTime.utc_now |> to_string
  end

  def convert_time(datetime) do
    timezone = Timezone.get("Australia/Sydney", Timex.now())
    Timezone.convert(datetime, timezone)
  end

  def uptime() do
    {uptime, _} = :erlang.statistics(:wall_clock)
    uptime
  end

  # def available_core() do
  #   :erlang.system_info(:logical_processors_online)

  # end

  # def get_memory() do
  #   :erlang.memory(:total)
  # end

  def get_sc_config_list() do
    {:ok, config_body} = Dashboard.get_json("config.json")
    # IO.inspect config_body
    Map.keys(config_body["superclusters"])
  end


  def update_gpu_count(sc_list) do

    sc_gpu_count = Enum.reduce sc_list, %{}, fn sc_name, acc ->
      cpu_freq_info = get_cpu_freq(sc_name, 1)
      gpu_num = cond do
        length(cpu_freq_info) == 0 -> 6

        true ->
        # latest information
        [last_info] = cpu_freq_info
        {:ok, gpu_count} = Map.fetch(last_info, :gpu_count)
        gpu_count

      end
      Map.put(acc, sc_name, gpu_num)

    end
    # IO.inspect sc_gpu_count
    sc_gpu_count
  end
end
