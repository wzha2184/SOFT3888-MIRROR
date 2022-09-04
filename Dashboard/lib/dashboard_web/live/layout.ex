defmodule DashboardWeb.Layout do
  use Phoenix.LiveView

  # alias LiveViewExamplesWeb.ObserverLive

  # ~H"""
  # <div class="view">
  # <%= ObserverLive.render(@settings[:view], assigns) %>
  # </div>
  # """

  def render(assigns) do
    ~H"""
    <section>
    <div class="current-time">
    <div id='message'></div>
    </div>
    <table>
      <th  style="color:#d1c7a7;"> <%= @time %> </th>
      <tr class="header">
        <th>Current System</th>
        <th>Uptime</th>
        <th>Available Core</th>
        <th>Disk Space</th>
        <th>Memory Usage</th>
        <th>Outside Weather Temperature</th>
        <th class="double"></th>
      </tr>

      <tr>
        <td class="bold">Localhost Test</td>
        <td><%= @uptime/1000 %> seconds</td>
        <td><%=@available_core %></td>
        <td><%= @disk_space %></td>
        <td><%=@available_mem%></td>
        <td colspan="2">26 °c</td>
      </tr>

      <tr class="header">
        <th>Database</th>
        <th>CPU FAN</th>
        <th>CPU OPT</th>
        <th>Cpu current freq</th>
        <th>Cpu min freq</th>
        <th>cpu maxfreq </th>
        <th class="double"></th>
      </tr>

      <tr>
        <td class="bold">Local Database Dynamic</td>
        <td><%=  %></td>
        <td> <%= %> </td>
        <td><%= %></td>
        <td><%= @cpu_min_freq %></td>
        <td><%= @cpu_max_freq %></td>
      </tr>

      <tr>
        <td class="bold">Local Database Last Value</td>
        <td><%= @cpu_fan_latest %></td>
        <td> <%= @cpu_opt_latest %> </td>
        <td><%= @cpu_current_freg_latest %></td>
        <td><%= @cpu_min_freq %></td>
        <td><%= @cpu_max_freq %></td>
      </tr>
    </table>
    </section>

    <div class="system-info">
    <div id='message'></div>
    <button id='add-button' phx-click="add-button" type="button"> Add new info to database</button>
    <button id='get-button' phx-click="get-button" type="button"> get last info from database</button>

    </div>
    <section class="row">
  <style>
    body {
      background-color: #151B22;
    }

    header {
      margin-bottom: 0;
      background-color: transparent;
      margin-top: 20px;
      display: flex;
      width: 1200px;
      margin: 0 auto;
    }

    header .madeby p {
      margin-bottom: 0;
      margin-left: 25px;
    }

    main.container {
      max-width: 1200px;
      padding: 0;
    }

    .observer {
      width: 1200px;
      background-color: #eee8d5;
      min-height: 500px;
    }

    .controls button {
      margin-bottom: 0;
      border: none;
    }


    .view {
      clear: both;
    }

    button {
      background-color: #268bd2;
      border-radius: 0;
    }

    button + button {
      margin: 0;
    }

    tr td{
      color: #FFFFFF;
    }

    .system-info {
      clear: both;
      background-color: #586e75;
      color: #eee8d5;
      width: 1200px;
      display: block;
      border-bottom: 1px dashed #eee8d547;
      padding: 10px;
    }

    table {
      width: 1200px !important;
      max-width: 1200px !important;
      box-sizing: border-box;
      overflow: hidden;
      margin-bottom: 0;
    }

    tbody {
      width: 1200px !important;
      max-width: 1200px !important;
    }

    table td:first-child, th:first-child {
      padding-left: 10px;
    }

    table th {
      font-family: sans-serif;
    }

    table td {
      font-family: monospace;
    }


    td.bold {
      font-weight: 700;
      font-size: 80%;
      font-family: sans-serif;
    }

    .underline {
      text-decoration: underline;
    }

    table .double {
      text-indent: -999999px;
      width: 100px;
    }

    table .header {
      background-color: #516F91;

      color: #eee8d5;
    }

    .schedulers .scheduler {
      border-bottom: 1px solid #2aa198;
    }

    /*table .header 516F91
    background: 151B22
    body {
      background-color: #d1c7a7;
    }
    table .header {
      background-color: #586e75;

      color: #eee8d5;
    }



    tr td{
      color: #FFFFFF;
    }

    table .header {
      background-color: #516F91;

      color: #eee8d5;
    }

    origonal:
    background:d1c7a7
    .header 586e75

    Solarized Dark
    $base03:    #002b36;
    $base02:    #073642;
    $base01:    #586e75;
    $base00:    #657b83;
    $base0:     #839496;
    $base1:     #93a1a1;
    $base2:     #eee8d5;
    $base3:     #fdf6e3;
    $yellow:    #b58900;
    $orange:    #cb4b16;
    $red:       #dc322f;
    $magenta:   #d33682;
    $violet:    #6c71c4;
    $blue:      #268bd2;
    $cyan:      #2aa198;
    $green:     #859900;
    */
    </style>
    </section>

    """
  end
end
