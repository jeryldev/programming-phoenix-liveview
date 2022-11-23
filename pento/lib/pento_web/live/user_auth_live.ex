defmodule PentoWeb.UserAuthLive do
  import Phoenix.LiveView
  alias Pento.Accounts
  import Phoenix.Component

  def on_mount(_, _params, %{"user_token" => user_token} = _session, socket) do
    # It means that on the initial mount, we can set
    # the live view’s socket assigns to contain the
    # current user stored in the Plug.Conn assigns.
    # Then, on the second, connected mount,
    # when we no longer have access to the Plug.Conn assigns,
    # we’ll fetch the current user from the database
    # using the token from the session.

    # IO.puts("Assign User  with socket.private:")
    # IO.inspect(socket.private)

    # socket = assign(socket, :current_user, Accounts.get_user_by_session_token(user_token))

    socket =
      assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(user_token) end)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/users/log_in")}
    end
  end
end
