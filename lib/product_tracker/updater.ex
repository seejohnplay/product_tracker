defmodule ProductTracker.Updater do
  alias ProductTracker.{PastPriceRecord, Product, Repo}
  require Logger

  def process(%{id: external_product_id, name: name} = record) do
    product = Repo.get_by(Product, external_product_id: external_product_id)

    case product do
      nil ->
        insert(record)

      %Product{product_name: ^name} ->
        update(product, %{record | price: string_to_price(record.price)})

      _mismatch ->
        Logger.error(
          "product (#{product.id}) name mismatch: " <>
            "product name: #{product.product_name}, record name: #{name}"
        )
    end
  end

  defp insert(%{discontinued: true}), do: {:ok, nil}

  defp insert(record) do
    Logger.info("creating a new product: #{record.name} (#{record.id})")

    %Product{
      external_product_id: record.id,
      price: string_to_price(record.price),
      product_name: record.name
    }
    |> Product.changeset()
    |> Repo.insert()
  end

  defp update(%{price: old_price}, %{price: old_price}), do: {:ok, nil}

  defp update(product, record) do
    product_changeset =
      product
      |> Product.changeset(%{price: record.price})

    past_price_record_changeset =
      %PastPriceRecord{
        product_id: product.id,
        price: product.price,
        percentage_change: percentage_change(product.price, record.price)
      }
      |> PastPriceRecord.changeset()

    {:ok, product_update} =
      Repo.transaction(fn ->
        Repo.insert(past_price_record_changeset)
        Repo.update(product_changeset)
      end)

    product_update
  end

  defp string_to_price("$" <> price) do
    price
    |> String.to_float()
    |> Kernel.*(100)
    |> round()
  end

  defp percentage_change(old_price, new_price) do
    (new_price - old_price)
    |> Kernel./(old_price)
    |> Kernel.*(100)
  end
end
