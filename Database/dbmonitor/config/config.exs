import Config

config :dbmonitor, Dbmonitor.Repo,
  database: "postgres",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :dbmonitor, ecto_repos: [Dbmonitor.Repo]
