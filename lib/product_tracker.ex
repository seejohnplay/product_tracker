defmodule ProductTracker do
  require Logger

  @moduledoc """
  Documentation for ProductTracker.
  """

  @doc """
  Updates product records
  """
  def update_records do
    Logger.info("updating products")

    case ProductTracker.API.fetch_product_updates() do
      {:ok, product_records} ->
        product_records
        |> Enum.each(fn record ->
          spawn(ProductTracker.Updater, :process, [record])
        end)

        Logger.info("update successful")

      {:error, reason} ->
        Logger.error(reason)
    end
  end
end
