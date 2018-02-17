defmodule ProductTracker.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add(:external_product_id, :integer, null: false, unique: true)
      add(:price, :integer, null: false)
      add(:product_name, :string, null: false, size: 40)

      timestamps()
    end

    create(unique_index(:products, [:external_product_id]))
  end
end
