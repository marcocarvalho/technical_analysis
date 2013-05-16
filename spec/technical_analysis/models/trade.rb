require 'spec_helper'

describe 'Portfolio and trades' do
  let(:cash) { 5000 }

  let(:portfolio) { Portfolio.where(cash: cash, risk_management_type: 'Classic').first_or_create }

  let(:symbol) { 'TST' }

  let(:date) { '2013-05-12' }
  let(:quantity) { 10 }
  let(:type) { :buy }
  let(:price) { 10.1 }
  let(:brokerage) { 5 }
  let(:subtotal) { nil }
  let(:total) { nil }

  subject { portfolio.trades.where(:symbol => symbol, :date => date, :quantity => quantity, :type => type, :price => price, :brokerage => brokerage, :total => total, :subtotal => subtotal).first_or_create }

  context 'no subtotal and total given' do
    it 'should calculate subtotal and total if not given' do
      subject.subtotal.should == quantity * price
      subject.total.should == quantity * price + brokerage
    end
  end

  context 'givin subtotal and total' do
    let(:total) { 2000 }
    let(:subtotal) { 1500 }
    it 'should respect values given' do
      subject.total.to_f.should    == total
      subject.subtotal.to_f.should == subtotal
    end
  end
end