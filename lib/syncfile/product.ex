defmodule Syncfile.Product do
  @moduledoc """
  Manages the product catalog, incluind their sync with external sources.
  """
  alias Syncfile.Product.ProductParser
  alias Syncfile.ProductSchema

  alias Syncfile.Repo

  import Ecto.Query

  @doc """
  Loads the CSV for a given path, parses it and returns a list of products data.

  ## Example:
      iex> Syncfile.Product.load_csv("test/fixtures/data.csv")
      [
        %{
          "branch_id" => "TUC",
          "part_number" => "0121F00548",
          "part_price" => "3.14",
          "short_desc" => "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56"
        },
        %{...},
        ...
      ]
  """
  def load_csv(path) do
    ProductParser.load_csv(path)
  end

  @doc """
  Receives a list of products metadata as argument and persists that into the database.

  This will perform and insert or update operation.

  ## Example:
      iex> products = [
      ...> %{
      ...>   "branch_id" => "TUC",
      ...>   "part_number" => "0121F00548",
      ...>   "part_price" => "3.14",
      ...>   "short_desc" => "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56"
      ...> }
      ]
      iex> Syncfile.Product.sync(products)
      :ok
  """
  def sync(products_data) do
    products_data |> Enum.each(&insert_or_update_product/1)
    :ok
  end

  @doc """
  Receives a list of products metadata as argument and delete all the persisted products that
  don't have their part_number listed.

  ## Example:
      iex> products = [
      ...> %{
      ...>   "branch_id" => "TUC",
      ...>   "part_number" => "0121F00548",
      ...>   "part_price" => "3.14",
      ...>   "short_desc" => "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56"
      ...> }
      ]
      iex> Syncfile.Product.delete_missing(products)
      {10, nil}
  """
  def delete_missing(products_data) do
    present_part_numbers = products_data |> Enum.map(& &1["part_number"])

    from(p in ProductSchema, where: not (p.part_number in ^present_part_numbers))
    |> Repo.delete_all()
  end

  @doc """
  Get all the items in the database

  ## Example:

      iex> Syncfile.Product.all
      [
        %Syncfile.ProductSchema{
          __meta__: #Ecto.Schema.Metadata<:loaded, "products">,
          branch_id: "TUC",
          id: 3581,
          inserted_at: ~N[2019-12-20 02:17:51],
          part_number: "0121F00548",
          part_price: #Decimal<3.1400>,
          short_desc: "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56",
          updated_at: ~N[2019-12-20 02:17:51]
        }
      ]
  """
  def all do
    from(p in ProductSchema, order_by: [asc: p.part_number]) |> Repo.all()
  end

  @doc """
  Return the item that matches a given part_number (if any).

  ## Example:

      iex> Syncfile.Product.get_by_part_number("0121F00548")
      %Syncfile.ProductSchema{
        __meta__: #Ecto.Schema.Metadata<:loaded, "products">,
        branch_id: "TUC",
        id: 3581,
        inserted_at: ~N[2019-12-20 02:17:51],
        part_number: "0121F00548",
        part_price: #Decimal<3.1400>,
        short_desc: "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56",
        updated_at: ~N[2019-12-20 02:17:51]
      }
  """
  def get_by_part_number(part_number) do
    Repo.get_by(ProductSchema, %{part_number: part_number})
  end

  defp insert_or_update_product(data) do
    part_number = data["part_number"]
    product = find_or_new_product(part_number)

    Syncfile.ProductSchema.changeset(product, data)
    |> Repo.insert_or_update!()
  end

  defp find_or_new_product(part_number) do
    case Repo.get_by(ProductSchema, %{part_number: part_number}) do
      nil -> %ProductSchema{}
      product -> product
    end
  end
end
