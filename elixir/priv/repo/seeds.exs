# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
# Seed database
# create company stuff

alias Homework.CompanyTransactions
alias Homework.Companies
alias Homework.Merchants
alias Homework.Users
alias Homework.Repo

#clear out db when run
Repo.clear_db()

#re-seed
{:ok, merchant1} = Merchants.create_merchant(%{name: "Apple", description: "Pay more"})
{:ok, merchant2} = Merchants.create_merchant(%{name: "Android", description: "Maybe pay less"})

{:ok, company1} = Companies.create_company(%{name: "Divvy", credit_line: 123456, available_credit: 123456})
{:ok, company2} = Companies.create_company(%{name: "Adobe", credit_line: 12045, available_credit: 12045})

{:ok, user1} = Users.create_user(%{first_name: "Justin", last_name: "Allen", dob: "10/04/1993", company_id: company1.id})
{:ok, user2} = Users.create_user(%{first_name: "Emma", last_name: "Allen", dob: "12/14/1997", company_id: company2.id})

CompanyTransactions.create_companyTransaction(
  %{
    amount: 100,
    credit: true,
    description: "Spent all my money",
    user_id: user1.id,
    merchant_id: merchant1.id,
    company_id: company1.id
  }
)

CompanyTransactions.create_companyTransaction(
  %{
    amount: 500,
    credit: true,
    description: "Spending all my money",
    user_id: user1.id,
    merchant_id: merchant2.id,
    company_id: company1.id
  }
)

CompanyTransactions.create_companyTransaction(
  %{
    amount: 1000,
    credit: true,
    description: "Still spending all my money",
    user_id: user1.id,
    merchant_id: merchant1.id,
    company_id: company1.id
  }
)

CompanyTransactions.create_companyTransaction(
  %{
    amount: 10,
    credit: true,
    description: "Tacos",
    user_id: user2.id,
    merchant_id: merchant1.id,
    company_id: company2.id
  }
)

CompanyTransactions.create_companyTransaction(
  %{
    amount: 10,
    credit: true,
    description: "Pizza",
    user_id: user2.id,
    merchant_id: merchant1.id,
    company_id: company2.id
  }
)
