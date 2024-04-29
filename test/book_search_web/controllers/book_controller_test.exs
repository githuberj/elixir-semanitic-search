defmodule BookSearchWeb.BookControllerTest do
  use BookSearchWeb.ConnCase

  import BookSearch.LibraryFixtures

  @create_attrs %{description: "some description", title: "some title", author: "some author", embedding: "some embedding"}
  @update_attrs %{description: "some updated description", title: "some updated title", author: "some updated author", embedding: "some updated embedding"}
  @invalid_attrs %{description: nil, title: nil, author: nil, embedding: nil}

  describe "index" do
    test "lists all books", %{conn: conn} do
      conn = get(conn, ~p"/books")
      assert html_response(conn, 200) =~ "Listing Books"
    end
  end

  describe "new book" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/books/new")
      assert html_response(conn, 200) =~ "New Book"
    end
  end

  describe "create book" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/books", book: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/books/#{id}"

      conn = get(conn, ~p"/books/#{id}")
      assert html_response(conn, 200) =~ "Book #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/books", book: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Book"
    end
  end

  describe "edit book" do
    setup [:create_book]

    test "renders form for editing chosen book", %{conn: conn, book: book} do
      conn = get(conn, ~p"/books/#{book}/edit")
      assert html_response(conn, 200) =~ "Edit Book"
    end
  end

  describe "update book" do
    setup [:create_book]

    test "redirects when data is valid", %{conn: conn, book: book} do
      conn = put(conn, ~p"/books/#{book}", book: @update_attrs)
      assert redirected_to(conn) == ~p"/books/#{book}"

      conn = get(conn, ~p"/books/#{book}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, book: book} do
      conn = put(conn, ~p"/books/#{book}", book: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Book"
    end
  end

  describe "delete book" do
    setup [:create_book]

    test "deletes chosen book", %{conn: conn, book: book} do
      conn = delete(conn, ~p"/books/#{book}")
      assert redirected_to(conn) == ~p"/books"

      assert_error_sent 404, fn ->
        get(conn, ~p"/books/#{book}")
      end
    end
  end

  defp create_book(_) do
    book = book_fixture()
    %{book: book}
  end
end
