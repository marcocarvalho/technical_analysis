require 'spec_helper'

describe Portfolio do
  let(:symbol) { 'SYMB' }
  let(:price) { 20.1 }
  let(:quantity) { 100 }
  let(:default_hash) { { type: type, brokerage: 0, date: Time.now } }
  let(:opts) { { symbol: symbol, price: price, quantity: quantity } }
  let(:time) { Time.new(2013, 1, 2, 12, 0) }
  subject { Portfolio.create(cash: 5000,risk_management_type: 'Classic') }
  before(:each) { Time.should_receive(:now).any_number_of_times.and_return(time) }

  context '#sell' do
    let(:type) { :sell }
    it do
      trades = mock(Trade)
      subject.should_receive(:trades).and_return(trades)
      trades.should_receive(:create).with(opts.merge(default_hash)).and_return(true)
      subject.sell(opts)
    end
  end

  context '#buy' do
    let(:type) { :buy }
    it do
      trades = mock(Trade)
      subject.should_receive(:trades).and_return(trades)
      trades.should_receive(:create).with(opts.merge(default_hash)).and_return(true)
      subject.buy(opts)
    end
  end
end