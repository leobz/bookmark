defmodule BookmarkWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  use Phoenix.Component

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.product_index_path(@socket, :index)}>
        <.live_component
          module={PentoWeb.ProductLive.FormComponent}
          id={@product.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.product_index_path(@socket, :index)}
          product: @product
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal()
          %>
        <% else %>
          <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>✖</a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def render_spinner(assigns) do
    text = assigns[:text]
    ~H"""
    <p aria-busy="true" style="color: white;">
      🤔 <%= text %>
    </p>
    """
  end

  def render_success(assigns) do
    text = assigns[:text]
    ~H"""
    <p style="color: green;">
      <i class="fa fa-check-circle" style="color:white;"></i>
      😄 <%= text %>
    </p>
    """
  end

  def render_fail(assigns) do
    text = assigns[:text]
    ~H"""
    <p style="color: red;">
      <i class="fa fa-exclamation-circle"></i>
      😞 <%= text %>
    </p>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.push("modal-closed")
  end
end
