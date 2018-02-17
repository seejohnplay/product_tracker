use Mix.Config

config :product_tracker, ProductTracker.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "product_tracker_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :product_tracker,
  ecto_repos: [ProductTracker.Repo],
  url: "https://externalservice.com/pricing/records.json",
  api_key: "abc123key"

 config :product_tracker, ProductTracker.Scheduler,
  jobs: [
    {"0 0 1 * *", {ProductTracker, :update_records, []}}
  ]

if :test == Mix.env do
  import_config "test.exs"
end