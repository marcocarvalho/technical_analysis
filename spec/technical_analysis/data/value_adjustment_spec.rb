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

    it 'should parse date_out' do
      subject.date_out.should == date_out
    end

    context 'Date obj' do
      let(:dt_in) { Date.new(2013,2,11) }
      it 'should accept date obj' do
        subject.date_in.should == dt_in
      end
    end

    context 'nil param' do
      let(:dt_in) { nil }
      it 'should raise error' do
        expect { subject.date_in}.to raise_error('parsable date/time or Time, Date, DateTime objects is needed')
      end
    end
  end

  context 'price in and out parsing' do
    let(:high) { 40 }
    let(:low)  { 20 }
    let(:open) { 30 }
    let(:close) { 35 }
    let(:volume) { 1_000_000_000 }
    let(:historical_quote) { HistoricalQuote.new(close: close, high: high, low: low, open: open, low: low, volume: volume) }
    before(:each) do
      subject.should_receive(:historical_quote).any_number_of_times.and_return(historical_quote)
    end

    it 'should understand candle price notation' do
      subject.parse_price_in(:close).should   == close
      subject.parse_price_in(:open).should    == open
      subject.parse_price_in(:high).should    == high
      subject.parse_price_in(:low).should     == low
      subject.parse_price_in(:volume).should  == volume
    end
  end
end