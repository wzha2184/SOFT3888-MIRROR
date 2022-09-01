import Config

config :dbmonitor, :"Elixir.Dbmonitor.repo",
  database: "postgres",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :dbmonitor, ecto_repos: [Dbmonitor.Repo]
