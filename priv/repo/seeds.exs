# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BookSearch.Repo.insert!(%BookSearch.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

path="priv/repo/booksummaries/booksummaries.txt"

df = Explorer.DataFrame.from_csv!(path, delimiter: "\t", header: false)
df = df[["column_3", "column_4", "column_7"]]
df = Explorer.DataFrame.rename(df, ["author", "title", "description"])

df
|> Explorer.DataFrame.to_rows()
|> Enum.each(&BookSearch.Library.create_book/1)
