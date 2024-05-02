defmodule BookSearchWeb.RagLive.Index do
  alias BookSearchWeb.Rag.Prompt
  use BookSearchWeb, :live_view

  alias BookSearch.Library

  @impl true
  def mount(_params, _session, socket) do
    dbg("hallo welt")

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"p" => prompt}, _uri, socket) do
    best_books = Library.search(prompt)

    [best_book | [second_best_book | _]] = best_books

    {:noreply,
     socket
     |> assign(completion: "", current_request: nil, prompt: "", books: best_books)
     |> start_streaming_completion(
       Prompt.compare_two_books({best_book, second_best_book}, prompt)
     )
     |> assign(prompt: prompt)
     |> assign(books: best_books)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp start_streaming_completion(socket, prompt) do
    {:ok, task} =
      Ollama.completion(Ollama.init(),
        model: "llama3",
        prompt: prompt,
        stream: self()
      )

    dbg(task)

    assign(socket, current_request: task)
  end

  # The streaming request sends messages back to the LiveView process.
  @impl true
  def handle_info({_request_pid, {:data, _data}} = message, socket) do
    pid = socket.assigns.current_request.pid

    new_chunk =
      case message do
        {^pid, {:data, %{"done" => false} = data}} ->
          # handle each streaming chunk

          data["response"]

        {^pid, {:data, %{"done" => true} = data}} ->
          # handle the final streaming chunk

          data["response"]

        {_pid, _data} ->
          ""
          # this message was not expected!
      end

    {:noreply, socket |> assign(:completion, socket.assigns.completion <> new_chunk)}
  end

  @impl true
  def handle_info({ref, {:ok, _}}, socket) do
    Process.demonitor(ref, [:flush])
    {:noreply, assign(socket, current_request: nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h2>Rag</h2>
    <p>Provide a topic and we will provide the perfect book!</p>

    <.search_form prompt={@prompt} />

    <h3>Recommended Books</h3>
    <%= for book <- @books do %>
      <p><%= book.title %> - <%= book.author %></p>
    <% end %>
    <p><%= @completion %></p>
    """
  end

  defp search_form(assigns) do
    ~H"""
    <div class="w-full">
      <form id="prompt" phx-submit="query" class="w-full flex space-x-2">
        <input
          placeholder="chat for a book"
          type="text"
          name="prompt"
          value={@prompt}
          id="prompt"
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

  @impl true
  def handle_event("query", %{"prompt" => prompt}, socket) do
    {:noreply, push_patch(socket, to: ~p"/rag?p=#{prompt}")}
  end
end
