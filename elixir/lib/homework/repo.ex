defmodule Homework.Repo do
  use Ecto.Repo,
    otp_app: :homework,
    adapter: Ecto.Adapters.Postgres

  def clear_db() do
    delete_all(Homework.Transactions.Transaction)
    delete_all(Homework.Users.User)
    delete_all(Homework.Companies.Company)
    delete_all(Homework.Merchants.Merchant)
  end
end
