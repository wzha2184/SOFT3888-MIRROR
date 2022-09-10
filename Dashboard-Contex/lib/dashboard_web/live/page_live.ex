defmodule DashboardWeb.PageLive do
  use DashboardWeb, :live_view

  alias Dashboard.Database.Cpu
  alias Dashboard.Database.CpuFreq
  alias Dashboard.Repo
  import Ecto.Query

  import Contex





  def render(assigns) do
    ~H"""
      <%= DashboardWeb.PageLayout.render(assigns) %>
      <sectoin>
      <div>

      <!--
      This is used to test chart
      Set the hooks.

      In this LiveView, it is the responsibility of Javascript to update the chart,
      so it is prevented in advance by `phx-update="ignore"`

      to prevent LiveView from updating the chart.

      <canvas
        id="chart-canvas"
        phx-update="ignore"
        phx-hook="LineChart"></canvas>
                    -->

      </div>

      </sectoin>

    """
  end

  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, any}
  def mount(_params, _session, socket) do

    tref = if connected?(socket) do
      schedule_refresh(3000, %{tref: nil})

      ## Use Javascript to make live chart
      # :timer.send_interval(10000, self(), :update_chart)
    end
    {
    :ok,
      initial_state(assign(socket, :tref, tref))
    }
  end

  def initial_state(socket) do
    socket
    |> assign(time: time())
    |> assign(score: 0)
    |> assign(uptime: uptime())
    |> assign(available_core: available_core())
    |> assign(available_mem: get_memory())
    |> assign(disk_space: get_disk_space())
    |> assign(cpu_fan_latest: get_latest_cpu_fan())
    |> assign(cpu_opt_latest: get_latest_cpu_opt())
    |> assign(cpu_current_freg_latest: get_cpu_current_freg_latest())
    |> assign(cpu_min_freq: get_cpu_min_freq())
    |> assign(cpu_max_freq: get_cpu_max_freq())
    |> assign(cpu_fan_random: Enum.random(700..2200))
    |> assign(cpu_opt_random: Enum.random(1000..2500))
    |> assign(cpu_current_freg_random: Enum.random(2200..3900))
    |> assign(cpu_chart_svg: get_cpu_chart())


  end

  def schedule_refresh(interval, %{tref: tref}) do
    # DashboardWeb.Endpoint.broadcast(topic, "date", %{time: DateTime.utc_now})
    if tref, do: :timer.cancel(tref)
    case :timer.send_interval(interval, self(), :refresh) do
      {:ok, tref} -> tref
      _ -> nil
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

  def get_cpu_chart() do
    cpu_freq = get_cpu_freq()
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

  def get_disk_space() do
    :application.start(:sasl)
    :application.start(:os_mon)
    [
      {_, disk_data, _},
      {_, _, _},
      {_, _, _},
      {_, _, _},
      {_, _, _},
      {_, _, _}
    ] = :disksup.get_disk_data()
    disk_data
  end

  def get_latest_cpu_fan() do
    query = last(Cpu)
    [cpu_info_map] = Repo.all(query)
    {_, cpu_fan} = Map.fetch(cpu_info_map, :CPU_FAN)
    cpu_fan
  end

  def get_latest_cpu_opt() do
    query = last(Cpu)
    [cpu_info_map] = Repo.all(query)
    {_, cpu_opt} = Map.fetch(cpu_info_map, :CPU_OPT)
    cpu_opt
  end

  def get_cpu_current_freg_latest() do
    query = last(CpuFreq)
    [cpu_freq_map] = Repo.all(query)
    {_, current_freq} = Map.fetch(cpu_freq_map, :cpu_current_freq)
    current_freq
  end

  def get_cpu_min_freq() do
    query = last(CpuFreq)
    [cpu_freq_map] = Repo.all(query)
    {_, min_freq} = Map.fetch(cpu_freq_map, :cpu_min_freq)
    min_freq
  end

  def get_cpu_max_freq() do
    query = last(CpuFreq)
    [cpu_freq_map] = Repo.all(query)
    {_, max_freq} = Map.fetch(cpu_freq_map, :cpu_max_freq)
    max_freq
  end

  def get_last_5_data() do
    cpu_info_query = from(m0 in Cpu, order_by: [desc: m0.id], limit: 5)

    Repo.all(cpu_info_query)
  end

  def handle_event("add-button", _, socket) do

    # params = %{CPU_FAN: "1000RPM", CPU_OPT: "1300RPM", CPU_ECC: "Presence Detected", Memory_Train_ERR: "N/A", Watchdog2: "N/A"}

    ##cpu_info table
    {_, list} = JSON.decode(Dashboard.get_random_data())

    changeset = Cpu.changeset(%Cpu{}, list["critical_sensors"])
    # IO.inspect(changeset)

    Repo.insert(changeset)

    #cpu_freq table
    {_, list} = JSON.decode(Dashboard.get_random_data())

    changeset = CpuFreq.changeset(%CpuFreq{}, list["cpu_freq"])
    # IO.inspect(changeset)

    Repo.insert(changeset)


    time = time()
    {
    :noreply,
    assign(
    socket,
    time: time)}
  end

  def handle_event("get-button", _, socket) do
    # IO.inspect Repo.all(from i in Cpu, select: i.cpu_current_freq)
    # IO.inspect Repo.get(Cpu, 54)

    {
      :noreply,
      assign(
      socket,
      cpu_fan_latest: get_latest_cpu_fan(),
      cpu_opt_latest: get_latest_cpu_opt(),
      cpu_current_freg_latest: get_cpu_current_freg_latest())}
  end



  # Refresh method Update methods
  def handle_info(:refresh, socket) do
    # ##cpu_info table
    # {_, list} = JSON.decode(Dashboard.get_random_data())

    # changeset = Cpu.changeset(%Cpu{}, list["critical_sensors"])

    # Repo.insert(changeset)

    # #cpu_freq table
    # {_, list} = JSON.decode(Dashboard.get_random_data())

    # changeset = CpuFreq.changeset(%CpuFreq{}, list["cpu_freq"])

    # Repo.insert(changeset)

    {:noreply, assign(socket, time: time(), uptime: uptime(),
    available_core: available_core(), available_mem: get_memory(), disk_space: get_disk_space(),
    cpu_fan_random: Enum.random(700..2200), cpu_opt_random: Enum.random(1000..2500),
    cpu_current_freg_random: Enum.random(2200..3900), cpu_chart_svg: get_cpu_chart())}
  end

  ## This is JavaScript chart handle refresh event
  # def handle_info(:update_chart, socket) do
  #   # # Generate dummy data and trigger "new-point" event
  #   # {:noreply,
  #   #  Enum.reduce(1..5, socket, fn i, acc ->
  #   #    push_event(
  #   #      acc,
  #   #      "new-point",
  #   #      %{label: "User #{i}", value: Enum.random(50..150) + i * 10}
  #   #    )
  #   #  end)}

  #    {:noreply,
  #    push_event(socket, "new-point", %{label: "Memory Usage", value: Enum.random(700..2200)})}
  # end





end
