require 'spec_helper'

describe HistoricalQuoteProxy do
  let(:start_date) { Time.new(2012, 10, 1) }
  let(:finish_date) { Time.new(2012, 10, 2) }
  let(:symbol) { 'symbol' }
  let(:cache) { [HistoricalQuote.new(symbol: symbol, date: start_date),
                 HistoricalQuote.new(symbol: symbol, date: finish_date)] }
  subject { HistoricalQuoteProxy }

  it 'should be a singleton' do
    subject.ancestors.include?(:Singleton)
  end

  context 'Simple methods' do
    subject { HistoricalQuoteProxy.instance }
    it '#append_cache_before?' do
      subject.should_receive(:start_in_cache).and_return(Time.new(2012), Time.new(2011))
      subject.should_receive(:start).and_return(Time.new(2011), Time.new(2012))
      subject.append_cache_before?.should be_true
      subject.append_cache_before?.should be_false
    end

    it '#append_cache_after?' do
      subject.should_receive(:finish_in_cache).and_return(Time.new(2011), Time.new(2012))
      subject.should_receive(:finish).and_return(Time.new(2012), Time.new(2011))
      subject.append_cache_after?.should be_true
      subject.append_cache_after?.should be_false
    end

    it '#refresh_cache?' do
      subject.refresh_cache?.should be_true

      subject.should_receive(:cache).twice.and_return(:somethig)
      subject.should_receive(:symbol).twice.and_return(:other_symbol)
      subject.should_receive(:symbol_in_cache).and_return(:symbol, :other_symbol)

      subject.refresh_cache?.should be_true
      subject.refresh_cache?.should be_false
    end

    # it '#refresh_cache' do
    #   subject.should_receive(:start).and_return(:start)
    #   subject.should_receive(:finish).and_return(:finish)
    #   subject.should_receive(:start_in_cache).and_return(:start_in_cache)
    #   subject.should_receive(:finish_in_cache).and_return(:finish_in_cache)
    #   subject.should_receive(:load_cache).with(:start, :finish, '==').and_return(:array_of_quotes)
    #   subject.should_receive(:start=).with(:start_in_cache)
    #   subject.should_receive(:finish=).with(:finish_in_cache)
    #   subject.refresh_cache.should == :refreshed
    #   subject.cache.should == :cache
    # end

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
    subject { HistoricalQuoteProxy.instance }

    it 'should do the first load' do
      subject.should_receive(:refresh_cache?).and_return(true)
      subject.should_receive(:refresh_cache).and_return(:refreshed)
      subject.load_if_necessary.should == :refreshed
    end

    it 'should append before if start date change' do
      subject.should_receive(:refresh_cache?).and_return(false)
      subject.should_receive(:append_cache_before?).and_return(true)
      subject.should_receive(:append_cache).with(:before).and_return(:appended_before)
      subject.load_if_necessary.should == :appended_before
    end

    it 'should append after if finish date change' do
      subject.should_receive(:refresh_cache?).and_return(false)
      subject.should_receive(:append_cache_before?).and_return(false)
      subject.should_receive(:append_cache_after?).and_return(true)
      subject.should_receive(:append_cache).with(:after).and_return(:appended_after)
      subject.load_if_necessary.should == :appended_after
    end
  end

  context 'info in cache' do
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