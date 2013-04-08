require 'spec_helper'

describe '#CandleArray' do
  subject do 
    t = TechnicalAnalysis::Data::CandleArray.new
    t.load_from_csv('spec/samples/1_month_petr4.csv')
    t
  end 
  it 'sma 9' do
    subject.sma(9).should == []
  end
end