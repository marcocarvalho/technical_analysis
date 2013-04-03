#require 'spec_helper'
#
#describe TechnicalAnalysis::Analysis::Patern do
#  Kernel.send(:remove_const, :A) if Kernel.const_defined?(:A)
#  class A; include TechnicalAnalysis::Analysis::Patern; end
#  subject { A.new }
#
#  context '#pattern_match_parse_params' do
#    it '' do
#      subject.pattern_match_parse_params(:up, :down, :up).should == [:>, :<]
#    end
#  end
#
#  it 'should it should' do
#    subject.search_pattern_parse_params(close: [:up, :down, :up]).should == { method: :close, ahead: 2, match: [:>, :<] }
#  end
#
#  it 'should' do
#    subject.search_pattern_parse_params(close: [:down, :up, :down]).should == { method: :close, ahead: 2, match: [:<, :>] }
#  end
#
#  it 'should' do
#    subject.search_pattern_parse_params(close: [:up, :up, :down, :up]).should == { method: :close, ahead: 3, match: [:<, :<, :>] }
#  end
#
#end