defmodule Syncfile.ProductSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :branch_id, :string
    field :part_number, :string
    field :part_price, :decimal
    field :short_desc, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:part_number, :branch_id, :part_price, :short_desc])
    |> validate_required([:part_number, :branch_id, :part_price, :short_desc])
  end
end
