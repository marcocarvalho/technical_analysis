require 'spec_helper'

describe TechnicalAnalysis::LastMaximumDisruption do
  subject { TechnicalAnalysis::LastMaximumDisruption.new([1,2,3,4]) }
  it 'should get signal for each entry point' do
    subject.should_receive(:range).and_return([1,2,3,4])
    subject.should_receive(:entry_point?).and_return(true, false, true, false)
    subject.should_receive(:signal).exactly(2).times.and_return(1)

    subject.run_setup.should == [1, 1]
  end

  define '#candle' do
    context 'Should return nil when index does not match item' do
      subject { TechnicalAnalysis::LastMaximumDisruption.new [:one_item_only] }

      it { subject.candle(-1).should be_nil }
      it { subject.candle(1).should be_nil  }
    end

    it 'Should return the item if no attribute name given' do
      subject { TechnicalAnalysis::LastMaximumDisruption.new [:one_item_only] }

      subject.candle(0).should == :one_item_only
    end

    it 'Should return the attribute value for the given attribute name' do
      candle = double(:candle)
      candle.should_receive(:my_fancy_attribute)
        .once
        .and_return(:value)

      subject { TechnicalAnalysis::LastMaximumDisruption.new [candle] }

      subject.candle(0, :my_fancy_attribute).should == :value
    end
  end
end