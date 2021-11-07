require './lib/atm'

describe Atm do
  subject { Atm.new }
  let(:account) { instance_double('Account') }

  before do
    # Before each test we need to add an attribute of 'balance'
    # to the 'account' object and set the value to '100'
    allow(account).to receive(:balance).and_return(100)

    # we also need to allow the fake 'account' to receive the new
    # balance using a setter method 'balance='
    allow(account).to receive(:balance=)
  end

  it 'is expected to have $1000 when instantiated' do
    expect(subject.funds).to eq 1000
  end

  it 'is expected to reduce funds on withdraw' do
    subject.withdraw 50, account
    expect(subject.funds).to eq 950
  end

  it 'is expected to reduce funds on withdraw' do
    expect { subject.withdraw 50, account }
      .to change { subject.funds }.from(1000).to(950)
  end

  it 'is expected to allow withdrawal if account has enough balance.' do
    # We need to tell the spec what to look for as the responce
    # and store that in a variable called `expected_outcome`.
    # Please note that we are omitting the `bills` part at the moment,
    # We will modify this test and add that later.

    expected_output = {
      status: true,
      message: 'success',
      date: Date.today,
      amount: 45
    }

    # We need to pass in two arguments to the `withdraw` method.
    # The amount of money we want to withdraw AND the `account` object.
    # The reason we pass in the `account` object is that the Atm needs
    # to be able to access information about the `accounts` balance
    # in order to be able to clear the transaction.
    expect(subject.withdraw(45, account)).to eq expected_output
  end

  # [...]
  it 'is expected to reject an withdrawal if account has insufficient funds' do
    expected_output = {
      status: false,
      message: 'insufficient funds',
      date: Date.today
    }
    # We know that the account created for the purpose of this test
    # has a balance of 100. So let's try to withdraw
    # a larger amount. In this case 105.
    expect(subject.withdraw(105, account)).to eq expected_output
  end
  # [...]
end
