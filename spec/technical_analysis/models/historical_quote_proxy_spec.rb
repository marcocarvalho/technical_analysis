require 'spec_helper'

describe HistoricalQuoteProxy do
  subject { HistoricalQuoteProxy }

  it 'should be a singleton' do
    subject.ancestors.include?(:Singleton)
  end

  it '#self.where' do
    mock = stub(:instance)
    mock.should_receive(:where).with(:opts).and_return(:value)
    subject.should_receive(:instance).and_return(mock)
    subject.where(:opts).should == :value
  end

  it '#where' do
    subject.instance.should_receive(:parse_hash).with(:opts)
    subject.instance.should_receive(:load_if_necessary)
    subject.instance.should_receive(:cache).and_return(:array)
    subject.instance.where(:opts).should == :array
  end

  it '#parse_hash' do
    subject.instance.parse_hash({ symbol: 'SYM', start: '2012-10-02', finish: Time.new(2012, 10, 3) })
    subject.instance.symbol.should  == 'SYM'
    subject.instance.start.should   == Time.new(2012, 10, 2)
    subject.instance.finish.should  == Time.new(2012, 10, 3)
  end

  context '#load_if_necessary' do
    it 'should load all if cache empty' do
      subject.instance.should_receive(:start).and_return(start_date)
      subject.instance.should_receive(:finish).and_return(finish_date)
      subject.instance.should_receive(:load_quote).with(start_date, finish_date, '=').and_return(cache)
      subject.instance.load_if_necessary
      subject.instance.cache.should == cache
    end
  end

  context 'info in cache' do
    let(:start_date) { Time.new(2012, 10, 1) }
    let(:finish_date) { Time.new(2012, 10, 2) }
    let(:symbol) { 'symbol' }
    subject { HistoricalQuoteProxy.instance }
    context 'no cache loaded yet' do
      it '#symbol_in_cache' do
        subject.symbol_in_cache.should be_empty
      end

      it '#start_in_cache' do
        subject.start_in_cache.should be_nil
      end

      it '#finish_in_cache' do
        subject.finish_in_cache.should be_nil
      end
    end

    context 'cache loaded' do
      context '#try_in_cache' do

        context 'empty cache' do
          it 'return default value if no cache' do
            subject.try_in_cache(:test, :blah).should be_nil
          end

          it 'should return given value if no cache' do
            subject.try_in_cache(:test, :blah, :value).should == :value
          end
        end

        context 'with cache' do
          let(:start_date) { Time.new(2012, 10, 1) }
          let(:finish_date) { Time.new(2012, 10, 2) }
          let(:symbol) { 'symbol' }
          let(:cache) { [HistoricalQuote.new(symbol: symbol, date: start_date),
                         HistoricalQuote.new(symbol: symbol, date: finish_date)] }

          before(:each) do
            subject.should_receive(:cache).any_number_of_times.and_return(cache)
          end

          it 'should return default value if no method exists' do
            subject.try_in_cache(:bleh, :symbol, 'default').should == 'default'
          end

          it 'should return symbol of first element' do
            subject.try_in_cache(:first, :symbol, 'default').should == symbol
          end

          it 'should return date of last element' do
            subject.try_in_cache(:last, :date, 'default').should == finish_date
          end
        end
      end

      it '#symbol_in_cache' do
        subject.should_receive(:try_in_cache).with(:first, :symbol, '').and_return('SYM')
        subject.symbol_in_cache.should == 'SYM'
      end

      it '#start_in_cache' do
        subject.should_receive(:try_in_cache).with(:first, :date).and_return(:some_date)
        subject.start_in_cache.should == :some_date
      end

      it '#finish_in_cache' do
        subject.should_receive(:try_in_cache).with(:last, :date).and_return(:some_other_date)
        subject.finish_in_cache.should == :some_other_date
      end
    end
  end
end