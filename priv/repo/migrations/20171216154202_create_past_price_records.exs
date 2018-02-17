defmodule ProductTracker.Repo.Migrations.CreatePastPriceRecords do
  use Ecto.Migration

  def change do
    create table(:past_price_records) do
      add(:product_id, references("products"))
      add(:price, :integer, null: false)
      add(:percentage_change, :float, null: false)

      timestamps()
    end
  end
end
