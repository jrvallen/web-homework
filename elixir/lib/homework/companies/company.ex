defmodule Homework.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset
  # import Ecto.Query
  # alias Homework.Transactions.Transaction

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "companies" do
    field(:name, :string)
    field(:credit_line, :integer)
    field(:available_credit, :integer)
    #field(:amount_available, CustomTypes.Reward) ----?--- (Maybe need a custom field type)

    timestamps()
  end

#  txn_amounts_per_company =
#    from t in Transaction,
#      group_by: t.company_id,
#      select: %{
#        company_id: t.company_id,
#        total_txn_amount: (t.amount)
#      }

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :credit_line, :available_credit])
    |> validate_required([:name, :credit_line, :available_credit])
  end
end
