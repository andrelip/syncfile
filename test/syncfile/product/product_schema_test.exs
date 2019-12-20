defmodule Syncfile.ProductSchemaTest do
  use Syncfile.DataCase

  alias Syncfile.ProductSchema

  @valid_attrs %{
    "branch_id" => "TUC",
    "part_number" => "0121F00548",
    "part_price" => "3.14",
    "short_desc" => "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56"
  }

  describe "#changeset" do
    test "should be valid for valid attrs" do
      changeset = ProductSchema.changeset(%ProductSchema{}, @valid_attrs)
      assert changeset.valid?
    end

    test "should be invalid for missing attrs" do
      changeset = ProductSchema.changeset(%ProductSchema{}, %{})
      refute changeset.valid?
    end

    # more tests here for more complex checks
  end
end
