defmodule ProductTracker.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      ProductTracker.Repo,
      ProductTracker.Scheduler
    ]

    opts = [strategy: :one_for_one, name: ProductTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
