defmodule BookSearchWeb.SearchLive.Index do
  use BookSearchWeb, :live_view

  alias BookSearch.Library

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(results: []) |> assign(query: "")}
  end

  @impl true
  def handle_params(%{"q" => query}, _uri, socket) do
    results = Library.search(query)

    {:noreply, socket |> assign(results: results) |> assign(query: query)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate_search", %{"search" => _query}, socket) do
    {:noreply, socket}
  end

  def handle_event("search_for_books", %{"search" => query}, socket) do
    {:noreply, push_patch(socket, to: ~p"/search?q=#{query}")}
  end

  @impl true
  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="w-full flex flex-col space-y-2">
      <.search_form query={@query} />
      <div :if={@query}>
        <h2 class="text-md">
          <span class="font-semibold">Searching For:</span>
          <span class="italic"><%= @query %></span>
        </h2>
      </div>
      <div>
        <.search_results results={@results} />
      </div>
    </div>
    """
  end

  defp search_form(assigns) do
    ~H"""
    <div class="w-full">
      <form
        id="search"
        phx-change="validate_search"
        phx-submit="search_for_books"
        class="w-full flex space-x-2"
      >
        <input
          placeholder="search for a book"
          type="text"
          name="search"
          value={@query}
          id="search"
          class={[
            "block w-full rounded-md border-gray-300 pr-12",
            "shadow-sm focus:border-indigo-500 focus:ring-indigo-500",
            "sm:text-sm"
          ]}
        />
        <button
          type="submit"
          class={[
            "inline-flex items-center rounded-md border",
            "border-transparent shadow-sm text-white",
            "bg-indigo-600 px-3 py-2 text-sm font-medium leading-4",
            "hover:bg-indigo-700 focus:outline-none focus:ring-2",
            "focus:ring-offset-2"
          ]}
        >
          Search
        </button>
      </form>
    </div>
    """
  end

  defp search_results(assigns) do
    ~H"""
    <div class="w-full">
      <ul role="list" class="-my-5 divide-y divide-gray-200">
        <%= for result <- @results do %>
          <li class="py-5">
            <div class="relative focus-within:ring-2
      focus-within:ring-indigo-500">
              <h3 class="text-sm font-semibold text-gray-800">
                <a href={~p"/books/#{result.id}"} class="hover:underline
      focus:outline-none">
                  <span class="absolute inset-0" aria-hidden="true"></span>
                  <%= result.title %>
                </a>
              </h3>
              <p class="mt-1 text-sm text-gray-600 line-clamp-2">
                <%= result.author %>
              </p>
            </div>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
