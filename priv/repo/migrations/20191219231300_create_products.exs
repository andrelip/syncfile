defmodule Syncfile.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :part_number, :string
      # branch_id denormalized for convention
      add :branch_id, :string
      add :part_price, :decimal, precision: 19, scale: 4, null: false
      add :short_desc, :text

      timestamps()
    end

    create unique_index(:products, [:part_number])
    create index(:products, [:branch_id])
  end
end
