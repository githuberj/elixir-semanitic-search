# BookSearch

My implementation of semantic search from the Machine learning in Elixir book.

To start your Phoenix server:

  * Run docker-compose up to start postgres
  * Run `mix setup` to install and setup dependencies. This will also seed the database.
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  * (optional) if you want to try the rag (/rag) endpoint, you have to start serving ollama with the [`ollama serve`](https://github.com/ollama/ollama) command.

Now you can visit [search](http://localhost:4000/search) or [rag](http://localhost:4000/rag) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).