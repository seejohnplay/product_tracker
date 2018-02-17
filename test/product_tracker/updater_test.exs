defmodule UpdaterTest do
  use ExUnit.Case, async: true

  alias ProductTracker.{PastPriceRecord, Product, Repo, Updater}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "when the product doesn't exist" do
    test "inserting the record" do
      record = %{
        id: 1,
        name: "Product1",
        price: "$100.00",
        category: "products",
        discontinued: false
      }

      {:ok, product} = Updater.process(record)

      assert product.id
      assert product.external_product_id == record.id
      assert product.price == 10000
      assert product.product_name == record.name
    end

    test "skipping insertion if the product is discontinued" do
      record = %{
        id: 1,
        name: "Product1",
        price: "$100.00",
        category: "products",
        discontinued: true
      }

      {:ok, product} = Updater.process(record)

      refute product
    end
  end

  describe "when the product already exists" do
    test "updating price of existing product if the names are the same" do
      external_product_id = 1

      product_attributes = %{
        external_product_id: external_product_id,
        price: 10000,
        product_name: "Product1"
      }

      %Product{}
      |> Product.changeset(product_attributes)
      |> Repo.insert()

      record = %{
        id: 1,
        name: "Product1",
        price: "$120.00",
        category: "products",
        discontinued: false
      }

      {:ok, updated_product} = Updater.process(record)
      past_price_record = Repo.get_by(PastPriceRecord, product_id: updated_product.id)

      assert updated_product.price == 12000
      assert past_price_record.price == 10000
      assert past_price_record.percentage_change == 20.0
    end

    test "skipping update if the price hasn't changed" do
      external_product_id = 1

      product_attributes = %{
        external_product_id: external_product_id,
        price: 10000,
        product_name: "Product1"
      }

      %Product{}
      |> Product.changeset(product_attributes)
      |> Repo.insert()

      record = %{
        id: 1,
        name: "Product1",
        price: "$100.00",
        category: "products",
        discontinued: false
      }

      {:ok, updated_product} = Updater.process(record)

      refute updated_product
    end
  end
end
