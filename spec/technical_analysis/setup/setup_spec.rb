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

    it 'should return default start position if none is given' do
      subject.start_at.should == 0
    end

    it 'should return default end position if none is given' do
      subject.end_at.should == 2
    end

    context 'passing start and end by opts' do
      let(:opts) { { start_at: '2012-04-02', end_at: '2012-04-03' } }
      it 'start at 1' do
        subject.start_at.should == 1
      end

      it 'end at 2' do
        subject.end_at.should == 2
      end
    end

    context 'passing start and end by param' do
      it 'start at param' do
        subject.start_at(1).should == 1
        subject.start_at('2012-04-01').should == 0
      end

      it 'end at param' do
        subject.end_at(1).should == 1
        subject.end_at('2012-04-02').should == 1
      end
    end
  end

  context 'inhited' do
    Kernel.send(:remove_const, :D) if Kernel.const_defined?(:D)
    class D < TechnicalAnalysis::Setup; end
    it 'should list inhited classes' do
      TechnicalAnalysis::Setup.all.include?(D).should be_true
    end
  end
end