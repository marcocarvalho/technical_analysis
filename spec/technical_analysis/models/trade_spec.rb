require 'spec_helper'

describe 'Portfolio and trades' do
  let(:cash) { 5000 }

  let(:portfolio) { Portfolio.create(cash: cash, risk_management_type: 'Classic') }

  let(:symbol) { 'TST' }

  let(:date) { '2013-05-12' }
  let(:quantity) { 10 }
  let(:type) { :buy }
  let(:price) { 10.1 }
  let(:brokerage) { 5 }
  let(:subtotal) { nil }
  let(:total) { nil }

  subject { portfolio.trades.create(:symbol => symbol, :date => date, :quantity => quantity, :type => type, :price => price, :brokerage => brokerage, :total => total, :subtotal => subtotal) }

  context 'no subtotal and total given' do
    it 'should calculate subtotal and total if not given' do
      expect(subject.subtotal).to eq quantity * price
      expect(subject.total.to_f).to eq quantity * price - brokerage
    end
    context 'sell type' do
      let(:type) { :sell }
      it 'aa' do
        expect(subject.subtotal).to eq quantity * price
        expect(subject.total.to_f).to eq quantity * price - brokerage
      end
    end
  end

  context 'givin subtotal and total' do
    let(:total) { 2000 }
    let(:subtotal) { 1500 }
    it 'should respect values given' do
      expect(subject.total.to_f).to eq total
      expect(subject.subtotal.to_f).to eq subtotal
    end
  end

  context 'portfolio cash up and down' do
    it 'should substract cash in portfolio when buy' do
      expect(subject.portfolio.cash).to eq cash - (quantity * price) + brokerage
    end
    context 'sell' do
      let(:type) { :sell }
      it 'should add cash in portfolio when sell' do
        expect(subject.portfolio.cash).to eq cash + (quantity * price) - brokerage
      end
    end
  end

end
