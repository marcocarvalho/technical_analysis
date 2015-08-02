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
      expect(subject.date_in).to eq Time.parse(dt_in)
    end

    it 'should parse date_out' do
      expect(subject.date_out).to eq date_out
    end

    context 'Date obj' do
      let(:dt_in) { Date.new(2013,2,11) }
      it 'should accept date obj' do
        expect(subject.date_in).to eq dt_in
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
    let(:historical_quote) { HistoricalQuote.new(close: close, high: high, low: low, open: open, volume: volume) }
    before(:each) do
      allow(subject).to receive(:historical_quote).and_return(historical_quote)
    end

    it 'should understand candle price notation' do
      expect(subject.parse_price_in(:close)).to eq close
      expect(subject.parse_price_in(:open)).to eq open
      expect(subject.parse_price_in(:high)).to eq high
      expect(subject.parse_price_in(:low)).to eq low
      expect(subject.parse_price_in(:volume)).to eq volume
    end

    it 'should return price near open' do
      expect((27..33).include?(subject.price_near(:open))).to eq(true)
    end

    it 'should return price above given notation' do
      expect((30..40).include?(subject.price_above(:open))).to eq(true)
    end

    it 'should raise error if high is given to price_above' do
      expect { subject.price_above(:high) }.to raise_error('high cannot be used in this method')
    end

    it 'should raise error if low is given to price_below' do
      expect { subject.price_below(:low) }.to raise_error('low cannot be used in this method')
    end

    it 'should return price above given notation' do
      expect((20..30).include?(subject.price_below(:open))).to eq(true)
    end

    it 'should call price_above|below|near in parse price' do
      allow(subject).to receive(:price_below).with(:open).and_return(1.1)
      allow(subject).to receive(:price_near).with(:close).and_return(1.2)
      allow(subject).to receive(:price_above).with(:open).and_return(1.3)
      expect(subject.parse_price_in(:below_open)).to eq 1.1
      expect(subject.parse_price_in(:near_close)).to eq 1.2
      expect(subject.parse_price_in(:above_open)).to eq 1.3
    end
  end

  context '#quantity' do
    context 'default' do
      let(:money_in) { 0 }
      let(:quantity) { :default }
      it 'should be 100' do
        expect(subject.quantity).to eq 100
      end
    end
    context 'by the money' do
      let(:quantity) { :default }
      let(:money_in) { 5050 }
      it 'should be 500 with change' do
        expect(subject.quantity).to eq 50
        expect(subject.change).to eq 50
      end
    end
  end
end
