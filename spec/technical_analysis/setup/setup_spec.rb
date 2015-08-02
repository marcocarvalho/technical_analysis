require 'spec_helper'

include TechnicalAnalysis::Data

describe TechnicalAnalysis::Setup do
  let(:candle_array) { [Candle.new(date: '2012-04-01'), Candle.new(date: '2012-04-02'), Candle.new(date: '2012-04-03')] }
  let(:opts) { Hash.new }
  subject { TechnicalAnalysis::Setup.new(candle_array: candle_array) }

  context 'index' do
    it 'should do index' do
      expect(subject.index).to eq({ Time.parse('2012-04-01') => 0, Time.parse('2012-04-02') => 1, Time.parse('2012-04-03') => 2 })
    end

    it 'should return default start position if none is given' do
      expect(subject.start_at).to eq 0
    end

    it 'should return default end position if none is given' do
      expect(subject.end_at).to eq 2
    end

  end

  context 'inhited' do
    Kernel.send(:remove_const, :D) if Kernel.const_defined?(:D)
    class D < TechnicalAnalysis::Setup; end
    it 'should list inhited classes' do
      expect(TechnicalAnalysis::Setup.list.include?(D)).to be(true)
    end
  end
end
