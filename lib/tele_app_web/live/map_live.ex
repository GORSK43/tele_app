defmodule TeleAppWeb.MapLive do 
  use TeleAppWeb, :live_component

  def mount(socket) do 
    IO.inspect(socket)
    {:ok, socket}
  end

  def render(assigns) do 
    ~H"""
    <div>
      <div class="w-full h-36 bg-teal-100 text-sky-800 mb-1 p-1">
        <%= @address %>
      </div>
      <div phx-hook="YMap" id="map" class="w-full" style="min-height:550px">
      </div>
    </div>
    """
  end
end
