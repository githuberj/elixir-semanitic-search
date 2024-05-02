defmodule BookSearchWeb.Rag.Prompt do
  def describe_book(book, user_prompt) do
    "Tell the user why this is the best possible book for his prompt. Don't name prompt or other technical terms." <>
      (book |> to_string()) <> "\n User Prompt:" <> user_prompt
  end

  def compare_two_books({book1, book2}, user_prompt) do
    "Compare the following two books given the user's prompt:" <>
      "\n User Prompt:" <>
      user_prompt <>
      "Books: \n" <>
      (book1 |> to_string()) <> "\n" <> (book2 |> to_string())
  end
end
