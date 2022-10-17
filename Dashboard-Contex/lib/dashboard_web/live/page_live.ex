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
    local_mechine_info: %{
      time: getTime(),
      uptime: uptime(),
      available_core: available_core(),
      available_mem: get_memory(),
    },

    settings: %{
      local_refresh_interval: 2000,
      sc_interval: 20000,
      bmc_interval_interval: 50000,
      view: :home,
      gpu: :gpu1,
    },

  }
  @gpus [:gpu1, :gpu2, :gpu3, :gpu4, :gpu5, :gpu6]

  @views [:home, :gpu, :cpu, :bmc]

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
      schedule_run_script(@initial_state[:settings][:sc_interval], %{tref: nil})
      ## Use Javascript to make live chart
      # :timer.send_interval(10000, self(), :update_chart)
    end

    :erlang.system_flag(:scheduler_wall_time, true)
    {:ok, initial_state(assign(socket, :tref, tref))}
  end

  def get_all_sc_info(sc_number, gpu_num) do

    # IO.inspect sc_number

    # # Check if data exists in the database
    # gpu_info = get_gpu_info(1)
    # [last_info] = cond do
    #   length(gpu_info) == 0 -> [%{Temperature: "N/A"}]
    #   true -> [last_info] = get_gpu_info(1)
    # end
    # {:ok, last_gpu_temp} = Map.fetch(last_info, :Temperature)

    # Get info from database

    # need update!!
    sc_gpu_infos_1 = case sc_number do
      "9" -> get_gpu_charts("GPU-f11c8a14-3c9b-48e8-8c02-7da2495d17ee", 5)
      _ -> get_gpu_charts("GPU-d1beb192-bcec-67d2-4a5f-51108e4f03d1", 5)
    end
    sc_gpu_infos_2 = case sc_number do
      "9" -> get_gpu_charts("GPU-5caf1987-9e67-8051-0080-9384b24a66db", 5)
      _ -> get_gpu_charts("GPU-70987dcb-d543-54bc-8ac5-fc3cfc530043", 5)
    end

    sc_gpu_infos = case gpu_num do
      :gpu1 -> sc_gpu_infos_1
      :gpu2 -> sc_gpu_infos_2

    end


    sc_cpu_freq_chart = get_cpu_freq_chart(5)

    server_status = get_all_server_status()
    # sc_status = get_sc_status(1)

    # %{last_gpu_temp: last_gpu_temp, sc_gpu_charts: sc_gpu_charts, sc_cpu_freq_chart: sc_cpu_freq_chart}
    %{
      current_sc_number: sc_number,
      last_info: %{
        last_gpu_temp: sc_gpu_infos_1[:last_gpu_temp],
        last_cpu_freq: sc_cpu_freq_chart[:last_cpu_freq],
        server_status: server_status,
        uuid: sc_gpu_infos_1[:uuid],
        sc_gpu_infos_1: sc_gpu_infos_1,
        sc_gpu_infos_2: sc_gpu_infos_2,
        sc_gpu_infos: sc_gpu_infos
      },
      charts: %{
        gpu_temp_svg: sc_gpu_infos_1[:gpu_temp_svg],
        gpu_free_mem_svg: sc_gpu_infos_1[:gpu_free_mem_svg],
        gpu_power_svg: sc_gpu_infos_1[:gpu_power_svg],
        cpu_freq_svg: sc_cpu_freq_chart[:cpu_freq_chart],
      }
    }
  end

  def initial_state(socket) do

    # All needed infos
    all_infos =  %{
      sc_info: get_all_sc_info("9" , :gpu1),

      bmc_info: %{

      }

    }

    # gpu_info = get_gpu_info(1)
    # [last_info] = cond do
    #   length(gpu_info) == 0 -> [%{Temperature: "N/A"}]
    #   true -> [last_info] = get_gpu_info(1)
    # end
    # {:ok, last_gpu_temp} = Map.fetch(last_info, :Temperature)


    # # [bmc_cpu_temp_chart, bmc_lan_temp_chart, bmc_chipset_fan_chart] = get_bmc_charts(5)
    # [gpu_temp_chart, gpu_free_mem_chart, gpu_power_chart] = get_gpu_charts(5)
    socket
    |> assign(local_mechine_info: @initial_state[:local_mechine_info])
    |> assign(settings: @initial_state[:settings])
    |> assign(sc_num: "")
    |> assign(sc9_status: "")
    |> assign(sc10_status: "")
    |> assign(bmc_sc9_status: "")
    |> assign(bmc_sc10_status: "")


    # ## BMC charts currently not available
    # |> assign(cpu_chart_svg: get_cpu_chart(10))
    # |> assign(bmc_cpu_temp_svg: bmc_cpu_temp_chart)
    # |> assign(bmc_lan_temp_svg: bmc_lan_temp_chart)
    # |> assign(bmc_chipset_fan_svg: bmc_chipset_fan_chart)



    # |> assign(last_gpu_temp: last_gpu_temp)

    # ## GPU charts
    # |> assign(gpu_temp_svg: gpu_temp_chart)
    # |> assign(gpu_free_mem_svg: gpu_free_mem_chart)
    # |> assign(gpu_power_svg: gpu_power_chart)

    |> assign(sc_info: all_infos[:sc_info])


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
    # :timer.send_interval(interval, self(), :run_script)
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
      |> update(:settings, &(put_in(&1[:gpu], String.to_existing_atom(gpu))))

    {:noreply,socket}
  end

  def handle_event("notify-button", _, socket) do

    server_status = get_all_server_status()


    Dashboard.call_discord_bot(server_status[:sc_9_status])


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
    sc_info = get_all_sc_info(socket.assigns.sc_num, socket.assigns.settings.gpu)
    if sc_info[:last_info][:server_status][:sc_9_status] != socket.assigns.sc9_status do
      # pid = spawn(
      #   fn ->
      #     Dashboard.call_discord_bot("SC9 status update: " <> sc_info[:last_info][:server_status][:sc_9_status])
      #   end
      # )
    end
    IO.inspect sc_info[:last_info][:server_status][:sc_9_status]
    IO.inspect socket.assigns.sc9_status

    {:noreply, assign(socket, local_mechine_info: update_local_info(), sc_info: sc_info, sc9_status: sc_info[:last_info][:server_status][:sc_9_status])}

  end



  # Run python script and store in database methods
  def handle_info(:run_script, socket) do


    to_database()

    # {:noreply, assign(socket, sc_info: update_sc_info())}
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
