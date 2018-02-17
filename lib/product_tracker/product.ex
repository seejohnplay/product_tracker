defmodule ProductTracker.Product do
  use Ecto.Schema
  alias ProductTracker.PastPriceRecord
  import Ecto.Changeset

  schema "products" do
    field(:external_product_id, :integer)
    field(:price, :integer)
    field(:product_name, :string)
    has_many(:past_price_records, PastPriceRecord)
    timestamps()
  end

  def changeset(product, params \\ %{}) do
    product
    |> cast(params, [:external_product_id, :price, :product_name])
    |> validate_required([:external_product_id, :price, :product_name])
    |> unique_constraint(:external_product_id)
  end
end
