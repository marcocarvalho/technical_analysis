require 'spec_helper'

describe TechnicalAnalysis::LastMaximumDisruption do
  it 'should get signal for each entry point' do
    candles = [1, 2, 3, 4]

    candles.each do |candle|
      # let's take the even as the selected
      is_even_number = candle % 2 == 0

      subject.should_receive(:entry_point?)
        .with(candle)
        .once
        .and_return(is_even_number)
      subject.should_receive(:signal)
        .with(candle)
        .once
        .and_return(candle) if is_even_number
    end

    subject.run_setup.should == [2, 4]
  end
end