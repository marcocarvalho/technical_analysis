require 'spec_helper'

describe HistoricalQuoteProxy do
  let(:start_date) { Time.new(2012, 10, 1) }
  let(:finish_date) { Time.new(2012, 10, 2) }
  let(:symbol) { 'symbol' }
  let(:cache) { [HistoricalQuote.new(symbol: symbol, date: start_date),
                 HistoricalQuote.new(symbol: symbol, date: finish_date)] }
  subject { HistoricalQuoteProxy }

  it 'should be a singleton' do
    expect(subject.ancestors).to include(Singleton)
  end

  context 'Simple methods' do
    subject { HistoricalQuoteProxy.instance }

    it '#load_quote' do
      obj = double(Object)
      allow(obj).to receive(:order).with(:date).and_return(:datum)
      subject.symbol = symbol
      allow(HistoricalQuote).to receive(:where).with('symbol = ? and date > ? and date < ?', symbol, start_date, finish_date).and_return(obj)
      expect(subject.load_quote(start_date, finish_date)).to eq :datum
    end

    it '#load_quote with like' do
      obj = double(Object)
      allow(obj).to receive(:order).with(:date).and_return(:datum)
      subject.symbol = symbol
      allow(HistoricalQuote).to receive(:where).with('symbol = ? and date >= ? and date <* ?', symbol, start_date, finish_date).and_return(obj)
      expect(subject.load_quote(start_date, finish_date, '=*')).to eq :datum
    end

    it '#append_cache before' do
      allow(subject).to receive(:load_quote).with(any_args()).and_return([1])
      subject.cache = [2]
      expect(subject.append_cache(:before)).to eq :appended_before
      expect(subject.cache).to eq [1,2]
    end

    it '#append_cache after' do
      allow(subject).to receive(:load_quote).with(any_args()).and_return([1])
      subject.cache = [2]
      expect(subject.append_cache(:after)).to eq :appended_after
      expect(subject.cache).to eq [2,1]
    end

    it '#refresh_cache' do
      subject.start  = start_date
      subject.finish = finish_date
      allow(subject).to receive(:cache).and_return(cache)
      allow(subject).to receive(:load_quote).with(start_date, finish_date, '==').and_return(:cache)
      expect(subject.refresh_cache).to eq :refreshed
      expect(subject.start).to         eq start_date
      expect(subject.finish).to        eq finish_date
    end

    it '#append_cache_before?' do
      allow(subject).to receive(:start_in_cache).and_return(Time.new(2012), Time.new(2011))
      allow(subject).to receive(:start).and_return(Time.new(2011), Time.new(2012))
      expect(subject.append_cache_before?).to be(true)
      expect(subject.append_cache_before?).to be(false)
    end

    it '#append_cache_after?' do
      allow(subject).to receive(:finish_in_cache).and_return(Time.new(2011), Time.new(2012))
      allow(subject).to receive(:finish).and_return(Time.new(2012), Time.new(2011))
      expect(subject.append_cache_after?).to be(true)
      expect(subject.append_cache_after?).to be(false)
    end

    it '#refresh_cache?' do
      expect(subject.refresh_cache?).to be(true)

      allow(subject).to receive(:cache).twice.and_return(:somethig)
      allow(subject).to receive(:symbol).twice.and_return(:other_symbol)
      allow(subject).to receive(:symbol_in_cache).and_return(:symbol, :other_symbol)

      expect(subject.refresh_cache?).to be(true)
      expect(subject.refresh_cache?).to be(false)
    end

  end

  it '#self.where' do
    mock = double(:instance)
    expect(mock).to receive(:where).with(:opts).and_return(:value)
    allow(subject).to receive(:instance).and_return(mock)
    expect(subject.where(:opts)).to eq :value
  end

  it '#where' do
    expect(subject.instance).to receive(:parse_hash).with(:opts)
    expect(subject.instance).to receive(:load_if_necessary)
    expect(subject.instance).to receive(:cache).and_return(:array)
    expect(subject.instance.where(:opts)).to eq :array
  end

  it '#parse_hash' do
    subject.instance.parse_hash({ symbol: symbol, start: '2012-10-02', finish: Time.new(2012, 10, 3) })
    expect(subject.instance.symbol).to  eq symbol
    expect(subject.instance.start).to   eq Time.new(2012, 10, 2)
    expect(subject.instance.finish).to  eq Time.new(2012, 10, 3)
  end

  context '#load_if_necessary' do
    subject { HistoricalQuoteProxy.instance }

    it 'should do the first load' do
      allow(subject).to receive(:refresh_cache?).and_return(true)
      allow(subject).to receive(:refresh_cache).and_return(:refreshed)
      expect(subject.load_if_necessary).to eq :refreshed
    end

    it 'should append before if start date change' do
      allow(subject).to receive(:refresh_cache?).and_return(false)
      allow(subject).to receive(:append_cache_before?).and_return(true)
      allow(subject).to receive(:append_cache).with(:before).and_return(:appended_before)
      expect(subject.load_if_necessary).to eq :appended_before
    end

    it 'should append after if finish date change' do
      allow(subject).to receive(:refresh_cache?).and_return(false)
      allow(subject).to receive(:append_cache_before?).and_return(false)
      allow(subject).to receive(:append_cache_after?).and_return(true)
      allow(subject).to receive(:append_cache).with(:after).and_return(:appended_after)
      expect(subject.load_if_necessary).to eq :appended_after
    end
  end

  context 'info in cache' do
    subject { HistoricalQuoteProxy.instance }
    context 'no cache loaded yet' do
      it '#symbol_in_cache' do
        expect(subject.symbol_in_cache).to be_empty
      end

      it '#start_in_cache' do
        expect(subject.start_in_cache).to be_nil
      end

      it '#finish_in_cache' do
        expect(subject.finish_in_cache).to be_nil
      end
    end

    context 'cache loaded' do
      context '#try_in_cache' do

        context 'empty cache' do
          it 'return default value if no cache' do
            expect(subject.try_in_cache(:test, :blah)).to be_nil
          end

          it 'should return given value if no cache' do
            expect(subject.try_in_cache(:test, :blah, :value)).to eq :value
          end
        end

        context 'with cache' do
          before(:each) do
            allow(subject).to receive(:cache).and_return(cache)
          end

          it 'should return default value if no method exists' do
            expect(subject.try_in_cache(:bleh, :symbol, 'default')).to eq 'default'
          end

          it 'should return symbol of first element' do
            expect(subject.try_in_cache(:first, :symbol, 'default')).to eq symbol
          end

          it 'should return date of last element' do
            expect(subject.try_in_cache(:last, :date, 'default')).to eq finish_date
          end
        end
      end

      it '#symbol_in_cache' do
        allow(subject).to receive(:try_in_cache).with(:first, :symbol, '').and_return(symbol)
        expect(subject.symbol_in_cache).to eq symbol
      end

      it '#start_in_cache' do
        allow(subject).to receive(:try_in_cache).with(:first, :date).and_return(:some_date)
        expect(subject.start_in_cache).to eq :some_date
      end

      it '#finish_in_cache' do
        allow(subject).to receive(:try_in_cache).with(:last, :date).and_return(:some_other_date)
        expect(subject.finish_in_cache).to eq :some_other_date
      end
    end
  end
end
