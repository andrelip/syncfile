defmodule Syncfile.Product do
  alias Syncfile.ProductSchema
  alias Syncfile.Product.ProductParser

  alias Syncfile.Repo

  import Ecto.Query

  def sync_file() do
    products_data = ProductParser.load_csv()
    sync(products_data)
  end

  def sync_file(path) do
    products_data = ProductParser.load_csv(path)
    sync(products_data)
  end

  def sync(products_data) do
    products_data |> Enum.each(&insert_or_update_product/1)
  end

  def all do
    from(p in ProductSchema, order_by: [asc: p.part_number]) |> Repo.all()
  end

  def get_by_part_number(part_number) do
    Repo.get_by(ProductSchema, %{part_number: part_number})
  end

  defp insert_or_update_product(data) do
    part_number = data["part_number"]
    product = find_or_new_product(part_number)

    Syncfile.ProductSchema.changeset(product, data)
    |> Repo.insert_or_update()
  end

  defp find_or_new_product(part_number) do
    case Repo.get_by(ProductSchema, %{part_number: part_number}) do
      nil -> %ProductSchema{}
      product -> product
    end
  end
end
