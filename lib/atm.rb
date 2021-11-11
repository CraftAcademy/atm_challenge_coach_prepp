require 'date'
class Atm
  attr_accessor :funds

  def initialize
    @funds = 1000
  end

  # NOTE: that we will also change 'value' to 'amount'
  # it is a better name for our domain
  def withdraw(amount, account)
    if insufficient_funds_in_account?(amount, account)
      generate_error_response('insufficient funds')
    elsif account_is_suspended?(account)
      generate_error_response('account is suspended')
    else
      perform_transaction(amount, account)
    end
  end

  private

  def insufficient_funds_in_account?(amount, account)
    amount > account.balance
  end

  def account_is_suspended?(account)
    account.suspended?
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

  def generate_error_response(message)
    {
      status: false,
      message: message,
      date: Date.today
    }
  end
end
