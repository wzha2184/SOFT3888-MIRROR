defmodule Dbmonitor.Repo do
  use Ecto.Repo,
    otp_app: :dbmonitor,
    adapter: Ecto.Adapters.Postgres
end
