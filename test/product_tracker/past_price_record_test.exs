defmodule PastPriceRecordTest do
  use ExUnit.Case, async: true

  alias ProductTracker.{PastPriceRecord, Product, Repo}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "creating a past price record" do
    product_attributes = %{external_product_id: 1, price: 100, product_name: "Product1"}

    {:ok, product} =
      %Product{}
      |> Product.changeset(product_attributes)
      |> Repo.insert()

    valid_attributes = %{product_id: product.id, price: 120, percentage_change: 20.0}

    past_price_record_changeset =
      %PastPriceRecord{}
      |> PastPriceRecord.changeset(valid_attributes)

    assert {:ok, _} = Repo.insert(past_price_record_changeset)
  end

  test "creating a past price record with an invalid product id" do
    product_id = -12345
    invalid_attributes = %{product_id: product_id, price: 120, percentage_change: 20.0}

    past_price_record_changeset =
      %PastPriceRecord{}
      |> PastPriceRecord.changeset(invalid_attributes)

    {:error, new_changeset} = Repo.insert(past_price_record_changeset)

    refute Repo.get(Product, product_id)
    assert {:product_id, {"does not exist", []}} in new_changeset.errors
  end

  test "creating a past price record without a product id, price, or percentage change" do
    missing_attributes = %{}

    product_changeset =
      %PastPriceRecord{}
      |> PastPriceRecord.changeset(missing_attributes)

    refute product_changeset.valid?
  end
end
