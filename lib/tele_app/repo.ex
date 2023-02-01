defmodule TeleApp.Repo do
  use Ecto.Repo,
    otp_app: :tele_app,
    adapter: Ecto.Adapters.Postgres
end
