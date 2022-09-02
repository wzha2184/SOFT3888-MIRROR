defmodule LiveboardWeb.Layout do
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
    <div class="system-info">
      <div id='message'></div>
      <button id='start-button' phx-click="start-button" type="button">Click Me!</button>
    </div>

    <table>
      <tr class="header">
        <th>Current System</th>
        <th>Uptime</th>
        <th>Voltage</th>
        <th>CPU Usage</th>
        <th>Memory Usage</th>
        <th>Outside Weather Temperature</th>
        <th class="double"></th>
      </tr>

      <tr>
        <td class="bold">Localhost Test</td>
        <td><%= @time %>/<%= @time %></td>
        <td class="bold">Smp Support</td>
        <td><%= @time %></td>
        <td class="bold">Allocated Mem</td>
        <td colspan="2"><%= @time %> (100%)</td>
      </tr>

      <tr class="header">
        <th>Database</th>
        <th>Mem Usage</th>
        <th>BIOS Info</th>
        <th>Cpu Info</th>
        <th>BMC</th>
        <th>Interval <%=" @settings[:interval]" %>ms</th>
        <th class="double"></th>
      </tr>

      <tr>
        <td class="bold">Total</td>
        <td><%= "@stats[:mem_stats][:total]" %></td>
        <td class="bold">Binary</td>
        <td><%= "@stats[:mem_stats][:binary]" %></td>
        <td class="bold">IO Output</td>
        <td colspan="2"><%= "@stats[:io][:output_human]" %></td>
      </tr>

      <tr>
        <td class="bold">Process</td>
        <td><%= "@stats[:mem_stats][:processes_used]" %></td>
        <td class="bold">Code</td>
        <td><%= "@stats[:mem_stats][:code]" %></td>
        <td class="bold">IO Input</td>
        <td colspan="2"><%= "@stats[:io][:input_human]" %></td>
      </tr>
      <tr>
        <td class="bold">Atom</td>
        <td><%= "@stats[:mem_stats][:atom]" %></td>
        <td class="bold">Reductions</td>
        <td><%= "@stats[:reds_stats]" %></td>
        <td class="bold">GC Count</td>
        <td colspan="2"><%= "@stats[:gc][:gcs]" %></td>
      </tr>
      <tr>
        <td class="bold">ETS</td>
        <td><%= "@stats[:mem_stats][:total]" %></td>
        <td class="bold">RunQueue / ErrorLoggerQueue</td>
        <td><%= "@stats[:runq_stats][:run_queue]" %>/<%= "@stats[:runq_stats][:error_logger_queue]" %></td>
        <td class="bold">GC Words Reclaimed</td>
        <td colspan="2"><%= "@stats[:gc][:words]" %></td>
      </tr>
    </table>

    <table class="schedulers">
      <tr class="header">
      <th colspan="4">
        Schedulers
      </th>

      </tr>
      <%= for {_i, cols} <- ["@stats[:schedulers][:formatted]"] do %>
        <tr>
          <%= for {schedno, col} <- cols do %>
            <td>
              <span><%= schedno %> : <%= col %>%</span>
              <div class="scheduler schedno-{schedno}" style="width: {col}">
              </div>
            </td>
          <% end %>
        </tr>
      <% end %>
    </table>

    <table>
      <tr class="header">
        <th>No</th>
        <th>PID</th>
        <th
          phx-click="set_top_attr_memory"
          class="sortable {@settings[:top_order]} {if @settings[:top_attribute] == :memory, do: @active}">
          Memory
        </th>
        <th>Name or Initial Call</th>
        <th
          phx-click="set_top_attr_reductions"
          class="sortable {@settings[:top_order]}  {if @settings[:top_attribute] == :reductions, do: @active}">
          Reductions
        </th>
        <th>MsqQueue</th>
        <th>Current Function</th>
      </tr>

      <%= for {%{
          pid: pid,
          stat: stat,
          name: name,
          reductions: reductions,
          message_queue_len: message_queue,
          current_function: current_function,
          initial_call: initial_call
        }, i} <- Enum.with_index(["@stats[:process_top]"]) do %>
        <tr>
          <td><%= i + 1 %></td>
          <td class="underline"><%= inspect(pid) %></td>
          <td><%= stat %></td>
          <td><%= name || inspect(initial_call) %> </td>
          <td><%= reductions %></td>
          <td><%= message_queue %></td>
          <td><%= inspect(current_function) %></td>
        </tr>
      <% end %>
    </table>
    </section>


    <section class="row">
      <article class="column">
        <h2>Resources</h2>
        <ul>
          <li>
            <a href="https://hexdocs.pm/phoenix/overview.html">Guides &amp; Docs</a>
          </li>
          <li>
            <a href="https://github.com/phoenixframework/phoenix">Source</a>
          </li>
          <li>
            <a href="https://github.com/phoenixframework/phoenix/blob/v1.6/CHANGELOG.md">v1.6 Changelog</a>
          </li>
        </ul>
      </article>
      <article class="column">
        <h2>Help</h2>
        <ul>
          <li>
            <a href="https://elixirforum.com/c/phoenix-forum">Forum</a>
          </li>
          <li>
            <a href="https://web.libera.chat/#elixir">#elixir on Libera Chat (IRC)</a>
          </li>
          <li>
            <a href="https://twitter.com/elixirphoenix">Twitter @elixirphoenix</a>
          </li>
          <li>
            <a href="https://elixir-slackin.herokuapp.com/">Elixir on Slack</a>
          </li>
          <li>
            <a href="https://discord.gg/elixir">Elixir on Discord</a>
          </li>
        </ul>
      </article>
      <style>
    body {
      background-color: #d1c7a7;
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

    .controls {
      width: 1200px;
      background-color: #586e75;
    }

    .tabs {
      float: left;
    }

    .controls button {
      margin-bottom: 0;
      border: none;
    }

    .interval-controls {
      float: right;
    }

    .interval-controls .interval-val {
      display: inline-block;
      width: 80px;
      text-align: center;
    }

    .interval-controls .btn-interval {
      background-color: #859900;
      font-size: 120%;
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

    button.active {
      background-color: #d33682;
      background-color: #586e75;
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

    th.sortable {
      cursor: pointer;
    }

    th.sortable:hover {
      background-color: #d33682;
    }

    table th.active {
      background-color: #d33682;
      min-width: 160px;
    }

    th.active.desc:after {
      content: '🔽';
      margin-left: 10px;
    }

    th.active.asc:after {
      content: '🔼';
      margin-left: 10px;
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
      background-color: #586e75;
      color: #eee8d5;
    }

    .schedulers .scheduler {
      border-bottom: 1px solid #2aa198;
    }

    /*
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
        <section>
          <h1>Your score: <%= @score %></h1>
          <h2>
          <%= @message %>
          </h2>
          <h2>
          <%= for n <- 1..10 do %>
          <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
          <% end %>
          </h2>
        </section>

        <section>
          <h2>
          <%= @message %>
          It's <%= @time %>
          </h2>
        </section>
    """
  end
end
