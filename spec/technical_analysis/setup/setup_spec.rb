require 'spec_helper'

include TechnicalAnalysis::Data

describe TechnicalAnalysis::Setup do
  let(:candle_array) { [Candle.new(date: '2012-04-01'), Candle.new(date: '2012-04-02'), Candle.new(date: '2012-04-03')] }
  let(:opts) { Hash.new }
  subject { TechnicalAnalysis::Setup.new(candle_array, opts) }

  context 'index' do
    it 'should do index' do
      subject.index.should == { Time.parse('2012-04-01') => 0, Time.parse('2012-04-02') => 1, Time.parse('2012-04-03') => 2 }
    end
  end
end