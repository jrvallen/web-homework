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

alias Homework.Transactions
alias Homework.Companies
alias Homework.Merchants
alias Homework.Users
alias Homework.Repo

#clear out db when run
Repo.clear_db()


#re-seed
merchant1 = Merchants.create_merchant(%{name: "Apple", description: "Pay more"})
merchant2 = Merchants.create_merchant(%{name: "Android", description: "Maybe pay less"})

company1 = Companies.create_company(%{name: "Divvy", credit_line: 123456, available_credit: 123456})
company2 = Companies.create_company(%{name: "Adobe", credit_line: 12045, available_credit: 12045})

user1 = Users.create_user(%{first_name: "Justin", last_name: "Allen", dob: "10/04/1993", company_id: company1.id})
user2 = Users.create_user(%{first_name: "Emma", last_name: "Allen", dob: "12/14/1997", company_id: company2.id})


#Transactions.create_transaction!(%{amount: 1000, credit: "true", description: "Test transaction", user_id: user1.id, merchant_id: merchant1.id, company_id: company1.id})
Transactions.create_transaction(%{amount: 100, debit: "true", description: "Anotha test transaction", user_id: user2.id, merchant_id: merchant2.id, company_id: company2.id})
