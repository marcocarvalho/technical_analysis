require 'spec_helper'

describe TechnicalAnalysis::LastMaximumDisruption do
  let(:values) { [ [10,5], [9,4], [10,5], [11,5], [12,5], [11,5], [12,5], [10,5], [9,5] ] }
  let(:candle_array) { values.map { |m| Candle.new(high: m.first, low: m.last) } }
  let(:entry_points) { [ Signal.new() ] }
  subject { TechnicalAnalysis::LastMaximumDisruption.new(candle_array) }
  it 'should return entry points' do
    subject.run_setup.should = entry_points
  end

end