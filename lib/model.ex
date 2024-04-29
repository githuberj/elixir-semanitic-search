defmodule Model do
  @moduledoc """
  Manages the BookSearch Model for similarity search.
  """

  @hf_model_repo "intfloat/e5-small-v2"

  defp load() do
    {:ok, model_info} = Bumblebee.load_model({:hf, @hf_model_repo})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, @hf_model_repo})

    {model_info, tokenizer}
  end

  def serving(opts \\ []) do
    opts =
      Keyword.validate!(opts, [
        :defn_options,
        compile: [sequence_length: 64, batch_size: 16]
      ])

    {model_info, tokenizer} = load()

    Bumblebee.Text.TextEmbedding.text_embedding(model_info, tokenizer, opts)
  end

  def predict(text) do
    Nx.Serving.batched_run(BookSearchModel, text)
  end
end
