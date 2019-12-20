defmodule SyncfileWeb.PageControllerTest do
  use SyncfileWeb.ConnCase

  alias Syncfile.Product
  alias Syncfile.ProductSchema
  alias Syncfile.Repo

  setup do
    products_data = Product.load_csv("test/fixtures/data.csv")
    Product.sync(products_data)
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Catalog uploader"
    assert html_response(conn, 200) =~ "Delete items not present in CSV"
  end

  test "GET /part_number/:part_number", %{conn: conn} do
    conn = get(conn, "/part_number/0121F00548")
    assert html_response(conn, 200) =~ "0121F00548"
    assert html_response(conn, 200) =~ "TUC"
    assert html_response(conn, 200) =~ "3.14"
    assert html_response(conn, 200) =~ "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56"
  end

  test "GET /list", %{conn: conn} do
    conn = get(conn, "/list")
    assert html_response(conn, 200) =~ "0121F00548"
    assert html_response(conn, 200) =~ "TUC"
    assert html_response(conn, 200) =~ "3.14"
    assert html_response(conn, 200) =~ "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56"
  end

  describe "PUT /" do
    test "with missing data", %{conn: conn} do
      conn = put(conn, "/", %{})
      assert html_response(conn, :unprocessable_entity) =~ "No file selected"
    end

    test "no change with same data if not marked to delete", %{conn: conn} do
      assert Repo.aggregate(ProductSchema, :count, :id) == 8

      upload = %Plug.Upload{path: "test/fixtures/data_with_one_new_entry.csv"}
      conn = put(conn, "/", %{"update" => %{"csv_file" => upload}})
      assert redirected_to(conn, 302) =~ "/list"

      assert Repo.aggregate(ProductSchema, :count, :id) == 9
    end

    test "discard missing data when check", %{conn: conn} do
      upload = %Plug.Upload{path: "test/fixtures/data_with_one_new_entry.csv"}
      conn = put(conn, "/", %{"update" => %{"csv_file" => upload, "delete_missing" => "true"}})
      assert redirected_to(conn, 302) =~ "/list"

      assert Repo.aggregate(ProductSchema, :count, :id) == 1
    end
  end
end
