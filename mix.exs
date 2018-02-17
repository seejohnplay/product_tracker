defmodule ProductTracker.Mixfile do
  use Mix.Project

  def project do
    [
      app: :product_tracker,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ProductTracker.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto, "~> 2.1"},
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:quantum, ">= 2.2.0"},
      {:timex, "~> 3.1"}
    ]
  end
end
