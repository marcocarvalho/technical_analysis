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
end