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

  it 'sma 5' do
    subject.sma(5).should == [16.924, 17.392, 17.686, 18.172000000000004, 18.608, 18.750000000000004, 18.836000000000002, 18.98, 19.034, 19.106, 19.124000000000002, 18.954, 18.862000000000002, 18.747999999999998, 18.645999999999997]
  end

  it 'sma 21' do
    #this should be empty becouse the shampe is just 20 periods...
    subject.sma(21).should == []
  end

  context 'more large set' do
    subject do
      t = TechnicalAnalysis::Data::CandleArray.new
      t.load_from_csv('spec/samples/petr4.csv')
      t
    end
    it 'sma #21' do
      # probaly it should round prices to 2 decimal...
      # TODO: check if is necessary more than 2 decimal
      subject.sma(21).map {|i| i.round(2)}.should == [23.65, 23.78, 23.88, 23.99, 24.15, 24.3, 24.43, 24.46, 24.48, 24.48, 24.52, 24.54, 24.51, 24.5, 24.51, 24.48, 24.42, 24.4, 24.41, 24.44, 24.44, 24.38, 24.36, 24.33, 24.28, 24.18, 24.13, 24.1, 24.13, 24.18, 24.24, 24.25, 24.24, 24.23, 24.24, 24.21, 24.17, 24.12, 24.07, 23.99, 23.86, 23.73, 23.64, 23.53, 23.39, 23.28, 23.21, 23.08, 22.92, 22.8, 22.67, 22.54, 22.41, 22.29, 22.18, 22.03, 21.91, 21.79, 21.69, 21.63, 21.54, 21.44, 21.39, 21.3, 21.24, 21.18, 21.09, 20.94, 20.79, 20.68, 20.53, 20.41, 20.32, 20.22, 20.09, 19.97, 19.86, 19.75, 19.62, 19.52, 19.37, 19.26, 19.18, 19.11, 19.04, 18.96, 18.89, 18.86, 18.83, 18.83, 18.85, 18.92, 18.93, 18.92, 18.85, 18.82, 18.77, 18.72, 18.69, 18.69, 18.69, 18.69, 18.72, 18.74, 18.7, 18.69, 18.69, 18.74, 18.76, 18.81, 18.86, 18.84, 18.8, 18.77, 18.75, 18.82, 18.92, 19.05, 19.13, 19.21, 19.27, 19.31, 19.36, 19.39, 19.48, 19.61, 19.73, 19.84, 19.91, 19.99, 20.09, 20.18, 20.28, 20.4, 20.52, 20.63, 20.73, 20.78, 20.83, 20.9, 20.94, 21.0, 21.02, 21.05, 21.09, 21.09, 21.12, 21.17, 21.26, 21.37, 21.48, 21.56, 21.62, 21.7, 21.75, 21.83, 21.91, 21.97, 22.04, 22.09, 22.16, 22.26, 22.33, 22.43, 22.51, 22.57, 22.62, 22.64, 22.67, 22.66, 22.64, 22.61, 22.57, 22.55, 22.51, 22.46, 22.39, 22.35, 22.31, 22.25, 22.21, 22.13, 22.04, 21.99, 21.95, 21.9, 21.82, 21.75, 21.67, 21.57, 21.43, 21.25, 21.08, 20.9, 20.73, 20.59, 20.45, 20.31, 20.16, 20.02, 19.89, 19.77, 19.68, 19.59, 19.47, 19.34, 19.27, 19.24, 19.19, 19.15, 19.14, 19.14, 19.2, 19.28, 19.4, 19.5, 19.54, 19.57, 19.62, 19.67, 19.73, 19.81, 19.86, 19.89, 19.93, 19.98, 20.02, 20.03, 20.02, 20.02, 20.03, 20.0, 19.97, 19.94, 19.88, 19.81, 19.75, 19.7, 19.64, 19.57, 19.52, 19.4, 19.29, 19.17, 19.08, 18.98, 18.89, 18.78, 18.68, 18.59, 18.51, 18.41, 18.3, 18.19, 18.07, 17.93, 17.8, 17.67, 17.56, 17.48, 17.41, 17.39, 17.44, 17.45, 17.51, 17.57, 17.62, 17.7, 17.76, 17.84, 17.9, 17.93, 17.98, 18.04, 18.11, 18.19]
    end
  end
end