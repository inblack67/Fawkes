defmodule Fawkes.Repo do
  use Ecto.Repo,
    otp_app: :fawkes,
    adapter: Ecto.Adapters.Postgres
end
