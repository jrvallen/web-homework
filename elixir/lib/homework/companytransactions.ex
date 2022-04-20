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
    case %Transaction{} |> Transaction.changeset(attrs) |> Repo.insert() do
      {:ok, newtxn} ->
        company_to_update = Companies.get_company!(newtxn.company_id)
        newamount = company_to_update.available_credit - newtxn.amount
        Companies.get_company!(newtxn.company_id)
          |> Companies.update_company(%{available_credit: newamount})
      error ->
        error
    end
  end

  def list_companyTransactions(comp_id) do
   query = from t in Transaction,
      where: t.company_id == ^comp_id
    Repo.all(query)
  end

end
