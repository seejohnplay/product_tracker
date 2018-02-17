defmodule ProductTest do
  use ExUnit.Case, async: true

  alias ProductTracker.{Product, Repo}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "creating a product" do
    valid_attributes = %{external_product_id: 1, price: 100, product_name: "Product1"}

    product_changeset =
      %Product{}
      |> Product.changeset(valid_attributes)

    assert {:ok, _} = Repo.insert(product_changeset)
  end

  test "creating a product without an external product id, price, or product name" do
    missing_attributes = %{}

    product_changeset =
      %Product{}
      |> Product.changeset(missing_attributes)

    refute product_changeset.valid?
  end

  test "creating a user without an external product id" do
    invalid_attributes = %{price: 100, product_name: "Product1"}

    product_changeset =
      %Product{}
      |> Product.changeset(invalid_attributes)

    assert {:external_product_id, {"can't be blank", [validation: :required]}} in product_changeset.errors
  end

  test "creating a user without a price" do
    invalid_attributes = %{external_product_id: 1, product_name: "Product1"}

    product_changeset =
      %Product{}
      |> Product.changeset(invalid_attributes)

    assert {:price, {"can't be blank", [validation: :required]}} in product_changeset.errors
  end

  test "creating a user without a product name" do
    invalid_attributes = %{external_product_id: 1, price: 100}

    product_changeset =
      %Product{}
      |> Product.changeset(invalid_attributes)

    assert {:product_name, {"can't be blank", [validation: :required]}} in product_changeset.errors
  end

  test "creating two products with the same external product id" do
    valid_attributes = %{external_product_id: 1, price: 100, product_name: "Product1"}

    product_changeset =
      %Product{}
      |> Product.changeset(valid_attributes)

    assert {:ok, _} = Repo.insert(product_changeset)
    {:error, new_changeset} = Repo.insert(product_changeset)
    assert {:external_product_id, {"has already been taken", []}} in new_changeset.errors
  end
end
