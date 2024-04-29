defmodule BookSearch.LibraryTest do
  use BookSearch.DataCase

  alias BookSearch.Library

  describe "books" do
    alias BookSearch.Library.Book

    import BookSearch.LibraryFixtures

    @invalid_attrs %{description: nil, title: nil, author: nil, embedding: nil}

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert Library.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert Library.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{description: "some description", title: "some title", author: "some author", embedding: "some embedding"}

      assert {:ok, %Book{} = book} = Library.create_book(valid_attrs)
      assert book.description == "some description"
      assert book.title == "some title"
      assert book.author == "some author"
      assert book.embedding == "some embedding"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Library.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", author: "some updated author", embedding: "some updated embedding"}

      assert {:ok, %Book{} = book} = Library.update_book(book, update_attrs)
      assert book.description == "some updated description"
      assert book.title == "some updated title"
      assert book.author == "some updated author"
      assert book.embedding == "some updated embedding"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = Library.update_book(book, @invalid_attrs)
      assert book == Library.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = Library.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> Library.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = Library.change_book(book)
    end
  end
end
