defmodule LiveboardWeb.PageLive do
  use LiveboardWeb, :live_view

  def render(assigns) do
    ~H"""
      <%= LiveboardWeb.Layout.render(assigns) %>
    """
  end

  def mount(_params, _session, socket) do
    # LiveboardWeb.Endpoint.subscribe(topic)
    tref = if connected?(socket) do
      schedule_refresh(1000, %{tref: nil})
    end
    {
    :ok,
      initial_state(assign(socket, :tref, tref))
    }
  end

  def initial_state(socket) do
    socket
    |> assign(time: DateTime.utc_now)
    |> assign(score: 0)
    |> assign(message: "Guess a number")
  end

  def schedule_refresh(interval, %{tref: tref}) do
    # LiveboardWeb.Endpoint.broadcast(topic, "date", %{time: DateTime.utc_now})
    if tref, do: :timer.cancel(tref)
    case :timer.send_interval(interval, self(), :refresh) do
      {:ok, tref} -> tref
      _ -> nil
    end
  end

  def time() do
    DateTime.utc_now |> to_string
  end

  def handle_event("start-button", _, socket) do
    time = time()
    {
    :noreply,
    assign(
    socket,
    time: time)}
  end

  def handle_event("guess", %{"number" => guess}=data, socket) do
    IO.inspect data
    message = "Your guess: #{guess}. Wrong. Guess again. "
    score = socket.assigns.score - 1
    time = time()
    {
    :noreply,
    assign(
    socket,
    message: message,
    score: score,
    time: time)}
  end

  # def handle_event("click date", %{"text" => text}, socket) do
  #   LiveboardWeb.Endpoint.broadcast(topic, "date", %{time: socket.assigns.time})
  #   {:noreply, socket}
  # end

  # def handle_info(%{event: "date", payload: message}, socket) do
  #   {:noreply, assign(socket, time: DateTime.utc_now())}
  # end

  def handle_info(:refresh, socket) do
    {:noreply, assign(socket, time: DateTime.utc_now())}
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
