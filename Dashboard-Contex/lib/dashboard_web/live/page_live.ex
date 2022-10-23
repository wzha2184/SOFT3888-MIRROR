defmodule DashboardWeb.PageLive do
    @moduledoc """
    Main Live Page
    """
  use DashboardWeb, :live_view

  alias DashboardWeb.Layout
  import Contex
  import Dashboard.InfoHandler

  # Set initial state
  @initial_state %{
    settings: %{
      local_refresh_interval: 2000,
      sc_interval: 25000,
      bmc_interval_interval: 60000,
    },

  }
  # @gpus [:gpu1, :gpu2, :gpu3, :gpu4, :gpu5, :gpu6]

  @views [:home, :gpu, :cpu, :bmc, :log]

  def render(view, assigns) when view in @views do
    Phoenix.View.render(DashboardWeb.PageView, "#{view}.html", assigns)
  end



  def render(assigns) do
    ~H"""
    <%= Layout.render(assigns) %>
    """
    # Phoenix.View.render(DashboardWeb.PageView, "index.html", assigns)
    # ~H"""

    # """
  end


  def mount(_session, _,%{assigns: _} = socket) do
    tref = if connected?(socket) do
      schedule_refresh(@initial_state[:settings][:local_refresh_interval], %{tref: nil})
      schedule_run_sc_script(@initial_state[:settings][:sc_interval], %{tref: nil})
      schedule_run_bmc_script(@initial_state[:settings][:bmc_interval_interval], %{tref: nil})

    end

    :erlang.system_flag(:scheduler_wall_time, true)
    {:ok, initial_state(assign(socket, :tref, tref))}
  end

  def get_all_sc_info(sc_number, gpu_num) do

    sc_gpu_infos = get_gpu_infos(sc_number, gpu_num, 5)

    sc_cpu_freq_infos = get_cpu_freq_infos(sc_number, 5)

    # server_status = get_all_server_status("sc", sc_list)
    # sc_status = get_sc_status(1)

    # %{last_gpu_temp: last_gpu_temp, sc_gpu_charts: sc_gpu_charts, sc_cpu_freq_chart: sc_cpu_freq_chart}
    %{
      current_sc_number: sc_number,
      last_info: %{

        sc_gpu_infos: sc_gpu_infos,
        sc_cpu_freq_infos: sc_cpu_freq_infos
      },
    }
  end

  def get_all_bmc_info(sc_number) do


    bmc_infos = get_bmc_infos(sc_number, 5)


    # server_status = get_all_server_status()
    # sc_status = get_sc_status(1)

    # %{last_gpu_temp: last_gpu_temp, sc_gpu_charts: sc_gpu_charts, sc_cpu_freq_chart: sc_cpu_freq_chart}
    %{
      current_sc_number: sc_number,
      last_info: %{
        # server_status: server_status,
        bmc_infos: bmc_infos,

      },
    }
  end

  def initial_state(socket) do
    call_sc_script()
    call_bmc_script()

    local_mechine_info =  %{
      time: getTime(),
      uptime: uptime(),
      # available_core: available_core(),
      # available_mem: get_memory(),
    }

    sc_list = get_sc_config_list()
    settings =  %{
      local_refresh_interval: @initial_state[:settings][:local_refresh_interval],
      sc_interval: @initial_state[:settings][:sc_interval],
      bmc_interval_interval: @initial_state[:settings][:bmc_interval_interval],
      view: :home,
      gpu_id: "1",
      sc_list: sc_list,
      # sc_gpu_count: get_sc_gpu_count(sc_list),
      # sc_gpu_count: %{"sc10" => 2, "sc9" => 2},
    }

    # All needed infos
    all_infos =  %{
      sc_info: get_all_sc_info("" , ""),

      bmc_info: get_all_bmc_info(""),

      bmc_log: get_bmc_info("", 30)
    }


    socket
    |> assign(local_mechine_info: local_mechine_info)
    |> assign(settings: settings)
    |> assign(sc_num: "")
    |> assign(sc_status: get_all_server_status("sc", sc_list))
    |> assign(bmc_status: get_all_server_status("bmc", sc_list))
    |> assign(sc_gpu_count: update_gpu_count(sc_list))
    # |> assign(sc_gpu_count: %{"sc10" => 6, "sc9" => 6})

    |> assign(sc_info: all_infos[:sc_info])
    |> assign(bmc_info: all_infos[:bmc_info])
    |> assign(bmc_log: all_infos[:bmc_log])



  end

  def schedule_refresh(interval, %{tref: tref}) do
    # DashboardWeb.Endpoint.broadcast(topic, "date", %{time: DateTime.utc_now})
    if tref, do: :timer.cancel(tref)
    case :timer.send_interval(interval, self(), :refresh) do
      {:ok, tref} -> tref
      _ -> nil
    end
  end

  def schedule_run_sc_script(interval, %{tref: tref}) do
    if tref, do: :timer.cancel(tref)
    case :timer.send_interval(interval, self(), :run_sc_script) do
      {:ok, tref} -> tref
      _ -> nil
    end
    # :timer.send_interval(interval, self(), :run_sc_script)
  end

  def schedule_run_bmc_script(interval, %{tref: tref}) do
    if tref, do: :timer.cancel(tref)
    case :timer.send_interval(interval, self(), :run_bmc_script) do
      {:ok, tref} -> tref
      _ -> nil
    end
    # :timer.send_interval(interval, self(), :run_sc_script)
  end

  def handle_event("render_" <> view_num, _path, socket) do
    send self(), :refresh
    [view, sc_num] = String.split(view_num, "_")
    socket =
      socket
      |> update(:settings, &(put_in(&1[:view], String.to_existing_atom(view))))
      |> assign(:sc_num, sc_num)
    {:noreply, socket}
  end

  def handle_event("choose_gpu_" <> gpu, _, socket) do
    send self(), :refresh

    socket =
      socket
      |> update(:settings, &(put_in(&1[:gpu_id], gpu))) #String.to_existing_atom(gpu)

    {:noreply,socket}
  end

  def handle_event("notify-button", _, socket) do

    # sc_list = get_sc_config_list()
    # {_, list} = JSON.decode(Dashboard.get_super_clusters_data())
    # Enum.each(sc_list, fn(s) -> sc_store_to_db(list, s) end)
    # call_sc_script()

    IO.inspect get_all_server_status("sc", socket.assigns.settings.sc_list)
    {:noreply,socket}
  end

  def update_local_info()do
    %{
      time: getTime(),
      uptime: uptime(),
      # available_core: available_core(),
      # available_mem: get_memory()
    }
  end

  # Refresh method Update methods
  def handle_info(:refresh, socket) do
    sc_info = get_all_sc_info(socket.assigns.sc_num, socket.assigns.settings.gpu_id)
    bmc_info = get_all_bmc_info(socket.assigns.sc_num)
    bmc_log = get_bmc_info(socket.assigns.sc_num, 30)

    {:noreply, assign(socket, local_mechine_info: update_local_info(),
    sc_info: sc_info, bmc_info: bmc_info, bmc_log: bmc_log
    )}

  end

  def call_discord_bot(type, sc_num, status_info) do
      _pid = spawn(
        fn ->
          Dashboard.call_discord_bot("#{type} Status Updated: \n" <>
          "Name: #{String.upcase(sc_num)} \n" <>
          "New Status: #{status_info} \n" <>
          "Time: #{getTime()}")
          # Dashboard.call_discord_bot("hello")
        end
      )
  end


  # Run python sc script and store in database methods
  def handle_info(:run_sc_script, socket) do

    # run super cluster script
    call_sc_script()

    sc_status = get_all_server_status("sc", socket.assigns.settings.sc_list)

    # IO.inspect sc_status
    for sc_name <- socket.assigns.settings.sc_list do
      [sc_update, sc_info] = String.split(sc_status[sc_name], "_", parts: 2)

      # sc
      if sc_update == "true" do
        call_discord_bot("Super Cluster", sc_name, sc_info)
      end
    end

    {:noreply, assign(socket, sc_gpu_count: update_gpu_count(socket.assigns.settings.sc_list), sc_status: sc_status)}
  end

  # Run python bmc script and store in database methods
  def handle_info(:run_bmc_script, socket) do

    # run bmc script
    call_bmc_script()

    bmc_status = get_all_server_status("bmc", socket.assigns.settings.sc_list)

    # IO.inspect bmc_status
    for sc_name <- socket.assigns.settings.sc_list do
      [bmc_update, bmc_info] = String.split(bmc_status[sc_name], "_", parts: 2)

      # bmc
      if bmc_update == "true" do
        call_discord_bot("BMC", sc_name, bmc_info)
      end

    end

    {:noreply, assign(socket, bmc_status: bmc_status)}
  end






end
