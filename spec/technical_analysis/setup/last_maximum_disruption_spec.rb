require 'spec_helper'

describe TechnicalAnalysis::LastMaximumDisruption do
  let(:c1) { Candle.new(date: '2013-01-01', high: 10, low: 5) }
  let(:c2) { Candle.new(date: '2013-01-02', high: 11, low: 5) }
  let(:c3) { Candle.new(date: '2013-01-03', high:  9, low: 5) }
  let(:c4) { Candle.new(date: '2013-01-04', high: 10, low: 5) }
  let(:c5) { Candle.new(date: '2013-01-05', high: 11, low: 5) }
  subject { TechnicalAnalysis::LastMaximumDisruption.new([c1, c2, c3, c4, c5]) }
  it 'should' do
    subject.run_setup.should == [
      { candle: c2, stop_gain: (c2.high * 1.07).round(2), stop_loss: c2.low },
      { candle: c4, stop_gain: (c4.high * 1.07).round(2), stop_loss: c4.low },
      { candle: c5, stop_gain: (c5.high * 1.07).round(2), stop_loss: c5.low }
    ]
  end
end