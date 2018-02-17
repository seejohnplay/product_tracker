defmodule ProductTracker.PastPriceRecord do
  use Ecto.Schema
  alias ProductTracker.Product
  import Ecto.Changeset

  schema "past_price_records" do
    field(:price, :integer)
    field(:percentage_change, :float)
    belongs_to(:product, Product)
    timestamps()
  end

  def changeset(past_price_records, params \\ %{}) do
    past_price_records
    |> cast(params, [:percentage_change, :price, :product_id])
    |> validate_required([:percentage_change, :price, :product_id])
    |> foreign_key_constraint(:product_id)
  end
end
