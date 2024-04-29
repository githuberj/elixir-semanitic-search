defmodule BookSearch.LibraryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BookSearch.Library` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        author: "some author",
        description: "some description",
        embedding: "some embedding",
        title: "some title"
      })
      |> BookSearch.Library.create_book()

    book
  end
end
