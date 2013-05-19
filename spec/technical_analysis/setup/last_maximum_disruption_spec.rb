require 'spec_helper'

describe TechnicalAnalysis::LastMaximumDisruption do
  it 'should get signal for each entry point' do
    subject.should_receive(:range).and_return([1,2,3,4])
    subject.should_receive(:entry_point?).exactly(4).times.and_return(true, false, true, false)
    subject.should_receive(:signal).exactly(2).times.and_return(1)

    subject.run_setup.should == [1, 1]
  end

  context '#candle' do
    subject { TechnicalAnalysis::LastMaximumDisruption.new candle_array: [:one_item_only] }
    it 'Should return nil when index does not match item' do
      subject.candle(1).should be_nil
    end

    it 'Should return the item if no attribute name given' do
      subject.candle(0).should == :one_item_only
    end

    context '' do
      let(:candle) do
        cdl = double(:candle)
        cdl.should_receive(:my_fancy_attribute)
          .once
          .and_return(:value)
        cdl
      end
      subject { TechnicalAnalysis::LastMaximumDisruption.new candle_array: [candle] }

      it 'Should return the attribute value for the given attribute name' do
        subject.candle(0, :my_fancy_attribute).should == :value
      end
    end
  end

  context '#trade?' do
    before(:each) do
      subject.should_receive(:candle)
        .once
        .with(-1, :high)
        .and_return(200)
    end

    it{ subject.trade?(100).should be_false }
    it{ subject.trade?(300).should be_true }
  end

  context '#stop_loss' do
    it 'Should get the rounded by 2 value of low' do
      low = double(:low)
      low.should_receive(:round).once.with(2).and_return(:rounded_by_2)

      subject.should_receive(:candle)
        .once
        .with(:idx, :low)
        .and_return(low)

      subject.stop_loss(:idx).should == :rounded_by_2
    end
  end

  context '#stop_gain' do
    before(:each) do
      subject.should_receive(:candle)
        .once
        .with(:idx, :high)
        .and_return(1.111)
    end

    it 'Should apply target and round by 2 value of high' do
      subject.stop_gain(:idx, 5).should == 5.56
    end

    it 'Should use a default target of 1.07' do
      subject.stop_gain(:idx).should == 1.19
    end
  end

  context '#entry_point?' do
    def try_entry(opts = {})
      subject.should_receive(:candle)
        .once
        .with(-1, :high)
        .and_return(opts[:yesterday_high])
      subject.should_receive(:candle)
        .once
        .with(0, :high)
        .and_return(opts[:today_high])

      subject.entry_point?(0)
    end

    it 'Should return true if todays high is bigger than yesterdays' do
      try_entry(yesterday_high: 100, today_high: 200).should be_true
    end

    it 'Should return false if yesterdays high is bigger than todays' do
      try_entry(yesterday_high: 200, today_high: 100).should be_false
    end

    it 'Should return false if today and yesterday high are equal' do
      try_entry(yesterday_high: 100, today_high: 100).should be_false
    end

  end

end