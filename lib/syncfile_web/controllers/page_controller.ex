defmodule SyncfileWeb.PageController do
  use SyncfileWeb, :controller

  alias Syncfile.Product

  def index(conn, _params) do
    products = Product.all()
    render(conn, "index.html", products: products)
  end

  def show(conn, %{"part_number" => part_number}) do
    product = Product.get_by_part_number(part_number)
    render(conn, "index.html", products: [product])
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def update(conn, %{"update" => %{"csv_file" => csv_file}} = params) do
    products_data = Product.load_csv(csv_file.path)
    delete_missing = get_in(params, ["update", "delete_missing"]) == "true"

    if delete_missing do
      Product.delete_missing(products_data)
    end

    Product.sync(products_data)

    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def update(conn, _) do
    conn
    |> put_flash(:error, "No file selected")
    |> put_status(:unprocessable_entity)
    |> render("new.html")
  end
end
