defmodule Homework.CompanyTransactions do
  @moduledoc """
  The Transactions context.
  """
  import Ecto.Query, warn: false
  alias Homework.Repo
  alias Homework.Transactions.Transaction
  alias Homework.Companies

  @doc """
  Creates a companyTransaction.

  ## Examples

      iex> create_companyTransaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_companyTransaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_companyTransaction(attrs \\ %{}) do
    with {:ok, new_txn} <- %Transaction{} |> Transaction.changeset(attrs) |> Repo.insert(),
      company_to_update <- Companies.get_company!(new_txn.company_id),
      {:ok, new_credit_line, new_available} <- calculate_credit(new_txn, company_to_update) do
      company_to_update |> Companies.update_company(%{credit_line: new_credit_line, available_credit: new_available})
    else
      _error -> {:error, "Insufficient funds"}
    end
  end

  def list_companyTransactions(comp_id) do
   query = from t in Transaction,
      where: t.company_id == ^comp_id
    Repo.all(query)
  end

  def calculate_credit(txn, company) do
    cond do
      txn.debit && !txn.credit && txn.amount <= company.available_credit ->
        {:ok, company.credit_line, company.available_credit - txn.amount}
      txn.credit && !txn.debit ->
        {:ok, company.credit_line + txn.amount, company.available_credit + txn.amount}
      true ->
        {:error, "Insufficient funds"}
    end
  end

end
