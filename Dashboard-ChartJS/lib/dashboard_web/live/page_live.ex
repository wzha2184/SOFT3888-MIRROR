defmodule DashboardWeb.PageLive do
  use DashboardWeb, :live_view

  alias Dashboard.Database.Cpu
  alias Dashboard.Database.CpuFreq
  alias Dashboard.Repo
  import Ecto.Query




  def render(assigns) do
    ~H"""
      <%= DashboardWeb.PageLayout.render(assigns) %>
      <sectoin>
      <div>
      <!--
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

    # DashboardWeb.Endpoint.subscribe(topic)
    tref = if connected?(socket) do
      schedule_refresh(1000, %{tref: nil})
      # :timer.send_interval(1000, self(), :refresh)

      :timer.send_interval(10000, self(), :update_chart)
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
    # |> assign(message: "Guess a number")
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

  end

  def schedule_refresh(interval, %{tref: tref}) do
    # DashboardWeb.Endpoint.broadcast(topic, "date", %{time: DateTime.utc_now})
    if tref, do: :timer.cancel(tref)
    case :timer.send_interval(interval, self(), :refresh) do
      {:ok, tref} -> tref
      _ -> nil
    end
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
    IO.inspect(changeset)

    Repo.insert(changeset)

    #cpu_freq table
    {_, list} = JSON.decode(Dashboard.get_random_data())

    changeset = CpuFreq.changeset(%CpuFreq{}, list["cpu_freq"])
    IO.inspect(changeset)

    Repo.insert(changeset)

    # result = Dashboard.get_all_data_capture()

    # {status, list} = JSON.decode(result)
    # IO.inspect(list["normal_sensors"])

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

  # def handle_event("guess", %{"number" => guess}=data, socket) do
  #   IO.inspect data
  #   message = "Your guess: #{guess}. Wrong. Guess again. "
  #   score = socket.assigns.score - 1
  #   time = time()
  #   {
  #   :noreply,
  #   assign(
  #   socket,
  #   message: message,
  #   score: score,
  #   time: time)}
  # end

  # def handle_event("click date", %{"text" => text}, socket) do
  #   DashboardWeb.Endpoint.broadcast(topic, "date", %{time: socket.assigns.time})
  #   {:noreply, socket}
  # end

  # def handle_info(%{event: "date", payload: message}, socket) do
  #   {:noreply, assign(socket, time: DateTime.utc_now())}
  # end

  def handle_info(:refresh, socket) do
    {:noreply, assign(socket, time: time(), uptime: uptime(),
    available_core: available_core(), available_mem: get_memory(), disk_space: get_disk_space(),
    cpu_fan_random: Enum.random(700..2200), cpu_opt_random: Enum.random(1000..2500), cpu_current_freg_random: Enum.random(2200..3900))}
  end

  def handle_info(:update_chart, socket) do
    # # Generate dummy data and trigger "new-point" event
    # {:noreply,
    #  Enum.reduce(1..5, socket, fn i, acc ->
    #    push_event(
    #      acc,
    #      "new-point",
    #      %{label: "User #{i}", value: Enum.random(50..150) + i * 10}
    #    )
    #  end)}


     {:noreply,
     push_event(socket, "new-point", %{label: "Memory Usage", value: Enum.random(700..2200)})}
  end

  # defp username do
  #   "User #{:rand.uniform(100)}"
  # end

  # defp topic do
  #   "load time"
  # end

  # def handle_info(:refresh, socket) do
  #   {:noreply, update(socket, :time, time())}
  # end




end
