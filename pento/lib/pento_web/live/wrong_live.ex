defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}
  alias PentoWeb.Router.Helpers, as: Routes

  def mount(_params, _session, socket),
    do: {:ok, socket}

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      It's <%= @time %>
    </h2>
    <%= render("game_state.html", assigns) %>
    """
  end

  def render("game_state.html", %{win: true} = assigns) do
    ~H"""
    <%= live_patch "Play again", to: Routes.live_path(@socket, PentoWeb.WrongLive) %>
    """
  end

  def render("game_state.html", %{win: false} = assigns) do
    ~H"""
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
      <% end %>
    </h2>
    """
  end

  def handle_params(_params, _uri, socket) do
    initial_assigns = %{
      score: 0,
      message: "Make a guess:",
      time: time(),
      winning_number: winning_number(),
      win: false
    }

    {:noreply, assign(socket, initial_assigns)}
  end

  def handle_event(
        "guess",
        %{"number" => guess} = _data,
        %{assigns: %{winning_number: winning_number}} = socket
      )
      when guess == winning_number do
    message = "Your guess: #{guess}. Correct. You win!"
    score = socket.assigns.score + 1

    {:noreply, assign(socket, message: message, score: score, time: time(), win: true)}
  end

  def handle_event("guess", %{"number" => guess} = _data, socket) do
    message = "Your guess: #{guess}. Wrong. Guess again. "
    score = socket.assigns.score - 1

    {:noreply, assign(socket, message: message, score: score, time: time())}
  end

  def time,
    do: DateTime.utc_now() |> to_string

  def winning_number,
    do:
      1..10
      |> Enum.map(&Integer.to_string/1)
      |> Enum.random()
end
