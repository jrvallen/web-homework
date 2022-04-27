defmodule Homework.CompanyTransactionTest do
  use Homework.DataCase

  alias Ecto.UUID
  alias Homework.Merchants
  alias Homework.Users
  alias Homework.Companies
  alias Homework.CompanyTransactions
  alias Homework.Repo

  describe "companyTransactions" do
    alias Homework.Transactions.Transaction

    setup do
      {:ok, merchant1} =
        Merchants.create_merchant(%{description: "some description", name: "some name"})

      {:ok, merchant2} =
        Merchants.create_merchant(%{
          description: "some updated description",
          name: "some updated name"
        })

      {:ok, company1} =
        Companies.create_company(%{
          name: "some name",
          credit_line: 100,
          available_credit: 100
        })

      {:ok, company2} =
        Companies.create_company(%{
          name: "some updated name",
          credit_line: 200,
          available_credit: 200
        })

      {:ok, user1} =
        Users.create_user(%{
          dob: "some dob",
          first_name: "some first_name",
          last_name: "some last_name",
          company_id: company1.id
        })

      {:ok, user2} =
        Users.create_user(%{
          dob: "some updated dob",
          first_name: "some updated first_name",
          last_name: "some updated last_name",
          company_id: company2.id
        })

      valid_attrs_debit = %{
        amount: 42,
        credit: false,
        debit: true,
        description: "some description",
        merchant_id: merchant1.id,
        user_id: user1.id,
        company_id: company1.id
      }

      valid_attrs_credit = %{
        amount: 50,
        credit: true,
        debit: false,
        description: "some description",
        merchant_id: merchant1.id,
        user_id: user1.id,
        company_id: company1.id
      }

      update_attrs_debit = %{
        amount: 110,
        credit: false,
        debit: true,
        description: "some updated description",
        merchant_id: merchant2.id,
        user_id: user1.id,
        company_id: company1.id
      }

      invalid_attrs = %{
        amount: nil,
        credit: nil,
        debit: nil,
        description: nil,
        merchant_id: nil,
        user_id: nil,
        company_id: nil
      }

      {:ok,
       %{
         valid_attrs_debit: valid_attrs_debit,
         valid_attrs_credit: valid_attrs_credit,
         update_attrs_debit: update_attrs_debit,
         invalid_attrs: invalid_attrs,
         merchant1: merchant1,
         merchant2: merchant2,
         user1: user1,
         user2: user2,
         company1: company1,
         company2: company2
       }}
    end

    test "create_copmanyTransaction/1 with valid DEBIT data creates a transaction & decreases associated company available_credit accordingly", %{
      valid_attrs_debit: valid_attrs_debit,
      merchant1: merchant1,
      user1: user1,
      company1: company1
    } do
      assert {:ok, %Transaction{} = transaction} = %Transaction{} |> Transaction.changeset(valid_attrs_debit) |> Repo.insert()
      assert transaction.amount == 42
      assert transaction.credit == false
      assert transaction.debit == true
      assert transaction.description == "some description"
      assert transaction.merchant_id == merchant1.id
      assert transaction.user_id == user1.id
      assert transaction.company_id == company1.id

      assert {:ok, %Companies.Company{} = company} = CompanyTransactions.create_companyTransaction(valid_attrs_debit) #returns updated company
      assert company.credit_line == 100
      assert company.available_credit == 58
      assert company.name == "some name"
    end

    test "create_copmanyTransaction/1 with valid DEBIT data creates a transaction that fails due to insufficient funds ", %{
      update_attrs_debit: update_attrs_debit,
      merchant2: merchant2,
      user1: user1,
      company1: company1
    } do
      assert {:ok, %Transaction{} = transaction} = %Transaction{} |> Transaction.changeset(update_attrs_debit) |> Repo.insert()
      assert transaction.amount == 110
      assert transaction.credit == false
      assert transaction.debit == true
      assert transaction.description == "some updated description"
      assert transaction.merchant_id == merchant2.id
      assert transaction.user_id == user1.id
      assert transaction.company_id == company1.id

      assert {:error, "Insufficient funds"} = CompanyTransactions.create_companyTransaction(update_attrs_debit)
    end


    test "create_copmanyTransaction/1 with valid CREDIT data creates a transaction & increases associated company available_credit & credit_line accordingly", %{
      valid_attrs_credit: valid_attrs_credit,
      merchant1: merchant1,
      user1: user1,
      company1: company1
    } do
      assert {:ok, %Transaction{} = transaction} = %Transaction{} |> Transaction.changeset(valid_attrs_credit) |> Repo.insert()
      assert transaction.amount == 50
      assert transaction.credit == true
      assert transaction.debit == false
      assert transaction.description == "some description"
      assert transaction.merchant_id == merchant1.id
      assert transaction.user_id == user1.id
      assert transaction.company_id == company1.id

      assert {:ok, %Companies.Company{} = company} = CompanyTransactions.create_companyTransaction(valid_attrs_credit) #returns updated company
      assert company.credit_line == 150
      assert company.available_credit == 150
      assert company.name == "some name"
    end

    #add one more test to make sure a company already with a transaction gets their available_credit & credit_line updated correctly
    test "create_copmanyTransaction/1 creates txn to CREDIT company that already had a DEBIT transaction & increases associated company available_credit & credit_line accordingly", %{
      valid_attrs_credit: valid_attrs_credit,
      valid_attrs_debit: valid_attrs_debit,
      merchant1: merchant1,
      user1: user1,
      company1: company1
    } do
      #first DEBIT transaction
      assert {:ok, %Transaction{} = transaction} = %Transaction{} |> Transaction.changeset(valid_attrs_debit) |> Repo.insert()
      assert transaction.amount == 42
      assert transaction.credit == false
      assert transaction.debit == true
      assert transaction.description == "some description"
      assert transaction.merchant_id == merchant1.id
      assert transaction.user_id == user1.id
      assert transaction.company_id == company1.id
      #verify DEBIT success on company
      assert {:ok, %Companies.Company{} = company} = CompanyTransactions.create_companyTransaction(valid_attrs_debit) #returns updated company
      assert company.credit_line == 100
      assert company.available_credit == 58
      assert company.name == "some name"
      #Second transaction on company (CREDIT)
      assert {:ok, %Transaction{} = transaction} = %Transaction{} |> Transaction.changeset(valid_attrs_credit) |> Repo.insert()
      assert transaction.amount == 50
      assert transaction.credit == true
      assert transaction.debit == false
      assert transaction.description == "some description"
      assert transaction.merchant_id == merchant1.id
      assert transaction.user_id == user1.id
      assert transaction.company_id == company1.id
      #Verify CREDIT was success on company
      assert {:ok, %Companies.Company{} = company} = CompanyTransactions.create_companyTransaction(valid_attrs_credit) #returns updated company
      assert company.credit_line == 150
      assert company.available_credit == 108
      assert company.name == "some name"
    end
  end
end
