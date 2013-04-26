require 'spec_helper'

describe TechnicalAnalysis::Data::ValueAdjustment do
  let(:sym) { :symbol }
  let(:dt_in) { '2013-01-12' }
  let(:date_out) { nil }
  let(:price_in) { nil }
  let(:money_in) { nil }
  let(:quantity) { nil }
  let(:opts) { {date_out: date_out, price_in: price_in, money_in: money_in, quantity: quantity} }
  let(:params) { [ sym, dt_in, opts ] }
  subject { TechnicalAnalysis::Data::ValueAdjustment.new(*params) }
  context '#date parsing' do
    let(:date_out) { Time.new(2013,4,14) }
    it 'should parse date_in' do
      subject.date_in.should == Time.parse(dt_in)
    end
  end
end