defmodule PentoWeb.UserAuthLive do
  import Phoenix.LiveView
  alias Pento.Accounts
  import Phoenix.Component

  def on_mount(_, _params, %{"user_token" => user_token} = _session, socket) do
    socket = assign(socket, :current_user, Accounts.get_user_by_session_token(user_token))

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/users/log_in")}
    end
  end
end
