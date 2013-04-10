require 'spec_helper'

describe 'Indicator' do
  subject do
    t = TechnicalAnalysis::Data::CandleArray.new
    t.load_from_csv('spec/samples/1_month_petr4.csv')
    t
  end
  it '#HiLo' do
    # probaly it should round prices to 2 decimal...
    # TODO: check if is necessary more than 2 decimal
#    subject.hilo.should == []
  end
end