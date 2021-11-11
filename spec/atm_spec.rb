require './lib/atm'

RSpec.describe Atm do
  let(:account) { instance_double('Account') }

  before do
    allow(account).to receive(:suspended?).and_return(false)
    allow(account).to receive(:balance=)
  end

  it 'is expected to have $1000 when instantiated' do
    expect(subject.funds).to eq 1000
  end

  describe 'Happy path' do
    before { allow(account).to receive(:balance).and_return(100) }

    it 'is expected to reduce funds on withdraw' do
      subject.withdraw 50, account
      expect(subject.funds).to eq 950
    end

    it 'is expected to reduce funds on withdraw' do
      expect { subject.withdraw 50, account }
        .to change { subject.funds }.from(1000).to(950)
    end

    it {
      expect { subject.withdraw 50, account }
        .to change { subject.funds }.from(1000).to(950)
    }

    it 'is expected to allow withdrawal if account has enough balance.' do
      expected_output = {
        status: true,
        message: 'success',
        date: Date.today,
        amount: 45
      }

      expect(subject.withdraw(45, account)).to eq expected_output
    end
  end

  describe 'Sad path' do
    describe 'when there are not enough funds in account balance' do
      before do
        allow(account).to receive(:balance).and_return(0)
      end
      it 'is expected to reject an withdrawal if account has insufficient funds' do
        expected_output = {
          status: false,
          message: 'insufficient funds',
          date: Date.today
        }
        expect(subject.withdraw(5, account)).to eq expected_output
      end
    end

    describe 'when the account/card is suspended' do
      before do
        allow(account).to receive(:balance).and_return(10)
        allow(account).to receive(:suspended?).and_return(true)
      end

      it 'is expected to reject an withdrawal' do
        expected_output = {
          status: false,
          message: 'account is suspended',
          date: Date.today
        }
        expect(subject.withdraw(5, account)).to eq expected_output
      end
    end

    
  end
end
