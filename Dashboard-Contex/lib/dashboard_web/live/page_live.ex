defmodule DashboardWeb.PageLive do
    @moduledoc """
    Main Live Page
    """
  use DashboardWeb, :live_view

  alias Dashboard.Repo
  import Contex
  import Dashboard.InfoHandler

  def render(assigns) do
    Phoenix.View.render(DashboardWeb.PageView, "index.html", assigns)
    # ~H"""

    # """
  end

  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, any}
  def mount(_params, _session, socket) do

    tref = if connected?(socket) do
      schedule_refresh(3000, %{tref: nil})
      schedule_run_script(20000, %{tref: nil})
      ## Use Javascript to make live chart
      # :timer.send_interval(10000, self(), :update_chart)
    end
    {
    :ok,
      initial_state(assign(socket, :tref, tref))
    }
  end

  def initial_state(socket) do
    gpu_info = get_gpu_info(2)
    [head | tail] = gpu_info
    # IO.inspect Map.fetch(head, :cpu_temp)
    last_gpu_temp = "N/A"
    {:ok, last_cpu_temp} = Map.fetch(head, :Temperature)


    [bmc_cpu_temp_chart, bmc_lan_temp_chart, bmc_chipset_fan_chart] = get_bmc_charts(5)
    [gpu_temp_chart, gpu_free_mem_chart, gpu_power_chart] = get_gpu_charts(5)
    socket
    |> assign(time: time())
    |> assign(score: 0)
    |> assign(uptime: uptime())
    |> assign(available_core: available_core())
    |> assign(available_mem: get_memory())
    |> assign(cpu_fan_random: Enum.random(700..2200))
    |> assign(cpu_opt_random: Enum.random(1000..2500))
    |> assign(cpu_current_freg_random: Enum.random(2200..3900))

    # ## BMC charts currently not available
    # |> assign(cpu_chart_svg: get_cpu_chart(10))
    # |> assign(bmc_cpu_temp_svg: bmc_cpu_temp_chart)
    # |> assign(bmc_lan_temp_svg: bmc_lan_temp_chart)
    # |> assign(bmc_chipset_fan_svg: bmc_chipset_fan_chart)
    |> assign(last_gpu_temp: last_cpu_temp)

    ## GPU charts
    |> assign(gpu_temp_svg: gpu_temp_chart)
    |> assign(gpu_free_mem_svg: gpu_free_mem_chart)
    |> assign(gpu_power_svg: gpu_power_chart)



  end

  def schedule_refresh(interval, %{tref: tref}) do
    # DashboardWeb.Endpoint.broadcast(topic, "date", %{time: DateTime.utc_now})
    if tref, do: :timer.cancel(tref)
    case :timer.send_interval(interval, self(), :refresh) do
      {:ok, tref} -> tref
      _ -> nil
    end
  end

  def schedule_run_script(interval, %{tref: tref}) do
    if tref, do: :timer.cancel(tref)
    case :timer.send_interval(interval, self(), :run_script) do
      {:ok, tref} -> tref
      _ -> nil
    end
  end


  def handle_event("add-button", _, socket) do


    # params = %{CPU_FAN: "1000RPM", CPU_OPT: "1300RPM", CPU_ECC: "Presence Detected", Memory_Train_ERR: "N/A", Watchdog2: "N/A"}

    ##BMC table multi-thread
    to_database()

    # changeset = Cpu.changeset(%Cpu{}, list["critical_sensors"])
    # IO.inspect(changeset)



    # #cpu_freq table
    # {_, list} = JSON.decode(get_super_clusters_data)

    # # changeset = CpuFreq.changeset(%CpuFreq{}, list["cpu_freq"])
    # # IO.inspect(changeset)

    # # Repo.insert(changeset)


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
      socket, time: time())}
  end



  # Refresh method Update methods
  def handle_info(:refresh, socket) do
    # #cpu_info table
    # {_, list} = JSON.decode(Dashboard.get_random_data())

    # changeset = Cpu.changeset(%Cpu{}, list["critical_sensors"])

    # Repo.insert(changeset)

    # #cpu_freq table
    # {_, list} = JSON.decode(Dashboard.get_random_data())

    # changeset = CpuFreq.changeset(%CpuFreq{}, list["cpu_freq"])

    # Repo.insert(changeset)

    {:noreply, assign(socket, time: time(), uptime: uptime(),
    available_core: available_core(), available_mem: get_memory(),
    cpu_fan_random: Enum.random(700..2200), cpu_opt_random: Enum.random(1000..2500),
    cpu_current_freg_random: Enum.random(2200..3900))}
  end

  # Run python script and store in database methods
  def handle_info(:run_script, socket) do
    gpu_info = get_gpu_info(2)
    [head | tail] = gpu_info
    # IO.inspect Map.fetch(head, :cpu_temp)
    last_gpu_temp = "N/A"
    {:ok, last_cpu_temp} = Map.fetch(head, :Temperature)
    [gpu_temp_chart, gpu_free_mem_chart, gpu_power_chart] = get_gpu_charts(5)
    to_database()

    {:noreply, assign(socket, gpu_temp_svg: gpu_temp_chart, gpu_free_mem_svg: gpu_free_mem_chart, gpu_power_svg: gpu_power_chart, last_gpu_temp: last_cpu_temp)}
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
