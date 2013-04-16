require 'spec_helper'

describe 'RiskManagement' do
  Kernel.send(:remove_const, :C) if Kernel.const_defined?(:C)
  class C; include TechnicalAnalysis::RiskManagement::Helpers; end
  subject do 
    C.new
  end
  it 'calculate mathematical_expectation' do
    subject.mathematical_expectation(1385, 433, 0.37).should == ((1 + (1385.0 / 433.0) * 0.37) ) - 1
  end

  it 'calculate recovery factor' do
    subject.recovery_factor(11850, 3290).round(1).should == 3.6
  end

  it 'calculate profit factor' do
    subject.profit_factor(11850, 3290).should == (11850 / 3290.to_f)
  end
end