defmodule Syncfile.ProductParserTest do
  use Syncfile.DataCase

  alias Syncfile.Product.ProductParser

  test "#load_csv" do
    items = ProductParser.load_csv("test/fixtures/data.csv")
    [item1 | _] = items
    assert Enum.count(items) == 9
    assert item1["branch_id"] == "TUC"
    assert item1["part_number"] == "0121F00548"
    assert item1["part_price"] == "3.14"
    assert item1["short_desc"] == "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56"
  end
end
