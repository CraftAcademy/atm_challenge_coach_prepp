require 'date'
class Atm
  attr_accessor :funds
  def initialize
    @funds = 1000
  end

  # note that we will also change 'value' to 'amount'
  # it is a better name for our domain
  def withdraw(amount, account)
    case
    when insufficient_funds_in_account?(amount, account)
      { 
        status: false, 
        message: 'insufficient funds', 
        date: Date.today 
      }
    else
      perform_transaction(amount, account)
    end
  end

  private

  def insufficient_funds_in_account?(amount, account)
    amount > account.balance
  end

  def perform_transaction(amount, account)
    # We DEDUCT the amount from the Atm's funds
    @funds -= amount
    # We also DEDUCT the amount from the accounts balance
    account.balance = account.balance - amount
    # and we return a responce for a successfull withdraw.
    { 
      status: true, 
      message: 'success', 
      date: Date.today, 
      amount: amount 
    }
  end
end