defmodule Syncfile.Product.ProductParser do
  @moduledoc """
  Parse the Product CSV containing:

  PART_NUMBER = identifier for a product
  BRANCH_ID = which kloeckner branch produces the product (TUC = tucson, CIN = cincinnati)
  PART_PRICE = price in USD
  SHORT_DESC = short description text about the product

  The CSV for the product uses `|` as the delimiter

  ## Example
    iex> content = "PART_NUMBER|BRANCH_ID|PART_PRICE|SHORT_DESC\n0121F00548|..."
    iex> GroupCollect.Report.ProductParser.process_csv(content)
    [
      %{
        "BRANCH_ID" => "TUC",
        "PART_NUMBER" => "0121F00548",
        "PART_PRICE" => "3.14",
        "SHORT_DESC" => "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56"
      },
      %{...},
      ...
    ]
  """

  def load_csv(path) do
    path
    |> File.read!()
    |> process_csv()
  end

  @doc """
  Receives the raw CSV content and format to a list of maps

  ## Example
      iex> content = "PART_NUMBER|BRANCH_ID|PART_PRICE|SHORT_DESC\n0121F00548|..."
      iex> GroupCollect.Report.ProductParser.process_csv(content)
      [
        %{
          "BRANCH_ID" => "TUC",
          "PART_NUMBER" => "0121F00548",
          "PART_PRICE" => "3.14",
          "SHORT_DESC" => "GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56"
        },
        %{...},
        ...
      ]

  """
  defp process_csv(csv_string) do
    csv_string
    |> CSV.parse_string(skip_headers: false)
    |> to_map
    |> Enum.filter(fn x -> x["part_number"] != "" end)
  end

  defp to_map(parsed_csv) do
    [header | body] = parsed_csv
    header = header |> Enum.map(&String.downcase(&1))

    body |> Enum.map(fn row -> Enum.zip(header, row) |> Enum.into(%{}) end)
  end
end
