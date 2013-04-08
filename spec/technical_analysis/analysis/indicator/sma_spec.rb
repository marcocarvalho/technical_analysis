require 'spec_helper'

describe '#CandleArray' do
  subject do
    t = TechnicalAnalysis::Data::CandleArray.new
    t.load_from_csv('spec/samples/1_month_petr4.csv')
    t
  end
  it 'sma 9' do
    # probaly it should round prices to 2 decimal...
    # TODO: check if is necessary more than 2 decimal
    subject.sma(9).should == [17.734444444444446, 17.973333333333333, 18.248888888888885, 18.536666666666665, 18.83, 18.946666666666662, 18.935555555555553, 18.95333333333333, 18.919999999999995, 18.90777777777777, 18.888888888888882]
  end
end