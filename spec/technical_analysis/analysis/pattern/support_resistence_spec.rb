require 'spec_helper'

describe 'Support & resistence' do
  Kernel.send(:remove_const, :A) if Kernel.const_defined?(:A)
  class A; include TechnicalAnalysis::Analysis::Pattern; end
  subject do 
    A.new
  end

  context 'resistence' do
    { [10.0, 11.0, 12.0, 11.0] => [12.0],
    [10.0, 11.0, 12.0]       => [],
    [12, 11, 10, 11]         => [],
    [1, 2, 3, 4, 4, 5, 4, 4, 3, 2, 1, 0.1, 1 ,2 , 1, 2, 3, 4, 3, 4, 5, 6, 7, 8, 7, 6, 8, 10] => [5, 2, 4, 8] }.each do |p, exp|
      it 'resistence' do
        subject.support_resistence(p, :<).should == exp
      end
    end
  end

  context 'resistence' do
    { [12.0, 11.0, 10.0, 11.0] => [10.0],
    [12.0, 11.0, 10.0]       => [],
    [10, 11, 12, 11]         => [],
    [1, 2, 3, 4, 4, 5, 4, 4, 3, 2, 1, 0.1, 1 ,2 , 1, 2, 3, 4, 3, 4, 5, 6, 7, 8, 7, 6, 8, 10] => [0.1, 6] }.each do |p, exp|
      it 'resistence' do
        subject.support_resistence(p, :>).should == exp
      end
    end
  end
end