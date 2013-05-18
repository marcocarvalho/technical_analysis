require 'spec_helper'

describe TechnicalAnalysis::LastMaximumDisruption do
  it 'should get signal for each entry point' do
    subject.should_receive(:range).and_return([1,2,3,4])
    subject.should_receive(:entry_point?).exactly(4).times.and_return(true, false, true, false)
    subject.should_receive(:signal).exactly(2).times.and_return(1)

    subject.run_setup.should == [1, 1]
  end
end