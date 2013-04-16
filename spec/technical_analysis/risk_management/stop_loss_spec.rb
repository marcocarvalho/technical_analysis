require 'spec_helper'

describe '' do
  Kernel.send(:remove_const, :B) if Kernel.const_defined?(:B)
  class B; include TechnicalAnalysis::RiskManagement::Helpers; end
  subject do 
    B.new
  end
  it 'calculate stop loss' do
    subject.stop_loss(10, 5).should == (10 - (( 10 - 5) * 1.33))
  end
end