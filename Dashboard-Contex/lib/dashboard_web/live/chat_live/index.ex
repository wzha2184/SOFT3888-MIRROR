defmodule DashboardWeb.ChatLive.Index do
  use DashboardWeb, :live_view
  def mount(_params, _session, socket) do
    if connected?(socket) do
      DashboardWeb.Endpoint.subscribe(topic)
      :timer.send_interval(1000, self(), :update_chart)
    end
    {:ok, assign(socket, username: username, messages: [])}
  end




  def handle_info(%{event: "message", payload: message}, socket) do
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end

  def handle_event("send", %{"text" => text}, socket) do
    DashboardWeb.Endpoint.broadcast(topic, "message", %{text: text, name: socket.assigns.username})
    {:noreply, socket}
  end

  def handle_info(:update_chart, socket) do
    # ダミーデータを生成し、"new-point"イベントを発信する。
    {:noreply,
     Enum.reduce(1..5, socket, fn i, acc ->
       push_event(
         acc,
         "new-point",
         %{label: "User #{i}", value: Enum.random(50..150) + i * 10}
       )
     end)}
  end

  defp username do
    "User #{:rand.uniform(100)}"
  end

  defp topic do
    "chat"
  end
end
