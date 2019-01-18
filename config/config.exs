# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :db, Db.Repo,
  database: "oriza",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :db,
  ecto_repos: [Db.Repo]

config :scheduler, Scheduler.Cron,
  jobs: [
    {"* * * * *",      {Scheduler.Rss, :run, []}}
  ]
