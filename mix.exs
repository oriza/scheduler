defmodule Scheduler.MixProject do
  use Mix.Project

  def project do
    [
      app: :scheduler,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Scheduler.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:db, path: "../db"},
      {:scraper, path: "../scraper"},
      {:timex, "~> 3.1"},
      {:quantum, "~> 2.3"}
    ]
  end
end
