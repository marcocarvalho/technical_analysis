require 'spec_helper'

describe TechnicalAnalysis::Data::Candle do
  let(:params) { [] }
  subject { TechnicalAnalysis::Data::Candle.new(*params) }
  it 'should initialize without parameters' do
    expect(subject.datetime).to eq(nil)
    expect(subject.open).to eq(nil)
    expect(subject.high).to eq(nil)
    expect(subject.low).to eq(nil)
    expect(subject.close).to eq(nil)
    expect(subject.volume).to eq(nil)
  end

  context 'Array as params' do
    let(:params) { ['2012-10-10', 10, 20,30,40,1000] }
    it 'should initialize candle' do
      expect(subject.date).to eq Time.parse('2012-10-10')
      expect(subject.open).to eq(10.0)
      expect(subject.high).to eq(20.0)
      expect(subject.low).to eq(30.0)
      expect(subject.close).to eq(40.0)
      expect(subject.volume).to eq(1000)
    end
  end

  context 'methods included' do
    let(:params) { ['2012-10-10', 20, 30, 20, 30,1000] }
    it 'stop_loss' do
      expect(subject.stop_loss).to eq ( 30 - ( ( 30 - 20 ) * 1.33 ) )
    end
  end

  context 'Array missing some last parameters' do
    let(:params) { ['2012-10-10',10,20,'30'] }
    it 'should initialize candle' do
      expect(subject.time).to eq Time.parse('2012-10-10')
      expect(subject.open).to eq(10.0)
      expect(subject.high).to eq(20.0)
      expect(subject.low).to eq(30.0)
      expect(subject.close).to eq(nil)
      expect(subject.volume).to eq(nil)
    end
  end

  context 'Hash initialize' do
    let(:params) { [{date: '2012-10-10', open: 10, high: '20', low: 30, close: 40, volume: 1000.0, bugabu: 'xxxx'}] }
    it 'shoudl initialize candle and ignore unknow parameters' do
      expect(subject.datetime).to eq Time.parse('2012-10-10')
      expect(subject.open).to eq(10.0)
      expect(subject.high).to eq(20.0)
      expect(subject.low).to eq(30.0)
      expect(subject.close).to eq(40.0)
      expect(subject.volume).to eq(1000)
    end
  end

  context 'Corrections' do
    let(:params) { [{date: '2012-10-10', open: 10, high: '20', low: 30, close: 40, volume: 1000.0}] }
    it 'shoudl initialize candle and ignore unknow parameters' do
      subject.apply_factor(2)
      expect(subject.open).to eq 20.0
      expect(subject.high).to eq 40.0
      expect(subject.low).to eq 60.0
      expect(subject.close).to eq 80.0
      expect(subject.volume).to eq 2000.0
    end

    it 'should apply faction of factors' do
      subject.apply_factor('0.5')
      expect(subject.open).to eq 5.0
      expect(subject.high).to eq 10.0
      expect(subject.low).to eq 15.0
      expect(subject.close).to eq 20.0
      expect(subject.volume).to eq 500.0
    end

    context '#quote model' do
      let(:params) { { date: '2012-10-10', open: 10, high: 20, low: 30, close: 40, volume: 1000 } }
      subject { Quote.new(params) }
      it '#apply_factor' do
        subject.apply_factor('0.5')
        expect(subject.open).to eq 5.0
        expect(subject.high).to eq 10.0
        expect(subject.low).to eq 15.0
        expect(subject.close).to eq 20.0
        expect(subject.volume).to eq 500.0
      end
    end

    context '#quote model' do
      let(:params) { { date: '2012-10-10', open: 10, high: 20, low: 30, close: 40, volume: 1000 } }
      subject { HistoricalQuote.new(params) }
      it '#apply_factor' do
        subject.apply_factor('0.5')
        expect(subject.open).to eq 5.0
        expect(subject.high).to eq 10.0
        expect(subject.low).to eq 15.0
        expect(subject.close).to eq 20.0
        expect(subject.volume).to eq 500.0
      end
    end
  end

  context 'Hash initialize with missing parameters' do
    let(:params) { [{time: '2012-10-10', open: 10, high: 20, low: 30, bugabu: 'xxxx'}] }
    it 'shoudl initialize candle and ignore unknow parameters' do
      expect(subject.date).to eq Time.parse('2012-10-10')
      expect(subject.open).to eq(10.0)
      expect(subject.high).to eq(20.0)
      expect(subject.low).to eq(30.0)
      expect(subject.close).to eq(nil)
      expect(subject.volume).to eq(nil)
    end
  end
end
