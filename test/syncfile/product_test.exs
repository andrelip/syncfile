defmodule Syncfile.ProductTest do
  use Syncfile.DataCase

  alias Syncfile.Product
  alias Syncfile.ProductSchema
  alias Syncfile.Repo

  test "#load_csv" do
    products = Product.load_csv("test/fixtures/data.csv")
    [product1 | _] = products
    assert Enum.count(products) == 9
    assert product1["branch_id"] == "TUC"
    assert product1["part_number"] == "0121F00548"
    assert product1["part_price"] == "3.14"
    assert product1["short_desc"] == "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56"
  end

  test "#sync #all #get_by_part_number" do
    products_data = Product.load_csv("test/fixtures/data.csv")
    Product.sync(products_data)

    assert Repo.aggregate(ProductSchema, :count, :id) == 8
    product = Product.all() |> List.first()

    assert product.branch_id == "TUC"
    assert product.part_number == "0121F00548"
    assert Decimal.eq?(product.part_price, "3.14")
    assert product.short_desc == "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56"

    assert product == Product.get_by_part_number("0121F00548")
  end

  test "#delete_missing" do
    all_products = Product.load_csv("test/fixtures/data.csv")
    Product.sync(all_products)
    assert Repo.aggregate(ProductSchema, :count, :id) == 8

    [_ | new_products] = all_products

    Product.delete_missing(new_products)
    assert Repo.aggregate(ProductSchema, :count, :id) == 7
  end
end
