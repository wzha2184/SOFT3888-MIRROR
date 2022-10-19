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
  @gpus [:gpu1, :gpu2, :gpu3, :gpu4, :gpu5, :gpu6]

  @views [:home, :gpu, :cpu, :bmc]

  def render(view, assigns) when view in @views do
    Phoenix.View.render(DashboardWeb.PageView, "#{view}.html", assigns)
  end

  # def update_settings() do
  #   %{
  #     local_refresh_interval: 2000,
  #     sc_interval: 20000,
  #     bmc_interval_interval: 50000,
  #     view: :home,
  #     gpu_id: "1",
  #     sc_list: get_sc_config_list(),
  #     sc_gpu_count: %{},
  #   }
  # end


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

      ## Use Javascript to make live chart
      # :timer.send_interval(10000, self(), :update_chart)
    end

    :erlang.system_flag(:scheduler_wall_time, true)
    {:ok, initial_state(assign(socket, :tref, tref))}
  end

  def get_all_sc_info(sc_number, gpu_num) do

    sc_gpu_infos = get_gpu_infos(sc_number, gpu_num, 5)

    sc_cpu_freq_infos = get_cpu_freq_infos(sc_number, 5)

    server_status = get_all_server_status()
    # sc_status = get_sc_status(1)

    # %{last_gpu_temp: last_gpu_temp, sc_gpu_charts: sc_gpu_charts, sc_cpu_freq_chart: sc_cpu_freq_chart}
    %{
      current_sc_number: sc_number,
      last_info: %{
        # last_gpu_temp: sc_gpu_infos_1[:last_gpu_temp],
        # last_cpu_freq: sc_cpu_freq_chart[:last_cpu_freq],
        server_status: server_status,
        # uuid: sc_gpu_infos_1[:uuid],
        # sc_gpu_infos_1: sc_gpu_infos_1,
        # sc_gpu_infos_2: sc_gpu_infos_2,
        sc_gpu_infos: sc_gpu_infos,
        sc_cpu_freq_infos: sc_cpu_freq_infos
      },
      # charts: %{
      #   # gpu_temp_svg: sc_gpu_infos_1[:gpu_temp_svg],
      #   # gpu_free_mem_svg: sc_gpu_infos_1[:gpu_free_mem_svg],
      #   # gpu_power_svg: sc_gpu_infos_1[:gpu_power_svg],
      #   # cpu_freq_svg: sc_cpu_freq_chart[:cpu_freq_chart],
      # }
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
      available_core: available_core(),
      available_mem: get_memory(),
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

      bmc_info: get_all_bmc_info("")


    }


    socket
    |> assign(local_mechine_info: local_mechine_info)
    |> assign(settings: settings)
    |> assign(sc_num: "")
    |> assign(sc9_status: "")
    |> assign(sc10_status: "")
    |> assign(bmc_sc9_status: "")
    |> assign(bmc_sc10_status: "")
    |> assign(sc_gpu_count: update_gpu_count(sc_list))
    # |> assign(sc_gpu_count: %{"sc10" => 6, "sc9" => 6})

    |> assign(sc_info: all_infos[:sc_info])
    |> assign(bmc_info: all_infos[:bmc_info])



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
    call_sc_script()

    {:noreply,socket}
  end

  def update_local_info()do
    %{
      time: getTime(),
      uptime: uptime(),
      available_core: available_core(),
      available_mem: get_memory()
    }
  end

  # Refresh method Update methods
  def handle_info(:refresh, socket) do
    sc_info = get_all_sc_info(socket.assigns.sc_num, socket.assigns.settings.gpu_id)
    bmc_info = get_all_bmc_info(socket.assigns.sc_num)
    if sc_info[:last_info][:server_status][:sc_9_status] != socket.assigns.sc9_status do
      # pid = spawn(
      #   fn ->
      #     Dashboard.call_discord_bot("SC9 status update: " <> sc_info[:last_info][:server_status][:sc_9_status])
      #   end
      # )
    end
    # IO.inspect sc_info[:last_info][:server_status][:sc_9_status]
    # IO.inspect socket.assigns.sc9_status

    {:noreply, assign(socket, local_mechine_info: update_local_info(),
    sc_info: sc_info, sc9_status: sc_info[:last_info][:server_status][:sc_9_status], bmc_info: bmc_info
    )}

  end



  # Run python sc script and store in database methods
  def handle_info(:run_sc_script, socket) do

    # run super cluster script
    call_sc_script()

    {:noreply, assign(socket, sc_gpu_count: update_gpu_count(socket.assigns.settings.sc_list))}
  end

  # Run python bmc script and store in database methods
  def handle_info(:run_bmc_script, socket) do

    # run bmc script
    call_bmc_script()

    {:noreply, socket}
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
