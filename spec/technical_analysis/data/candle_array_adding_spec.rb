require 'spec_helper'

describe TechnicalAnalysis::Data::CandleArray do
  context '#adding Candles' do
    it 'by array' do
      expect(subject.count).to eq(0)
      subject << ['2013-01-01', 10,20,30,40,1000]
      expect(subject.count).to eq(1)
      expect(subject.first.date).to  eq Time.parse('2013-01-01')
      expect(subject.first.open).to  eq(10.0)
      expect(subject.first.high).to  eq(20.0)
      expect(subject.first.low).to   eq(30.0)
      expect(subject.first.close).to eq(40.0)
      expect(subject.first.volume).to eq(1000)
    end

    it 'by hash' do
      expect(subject.count).to eq(0)
      subject << { date: '2013-01-01', open:10, high:20, low:30, close:40, volume:1000 }
      expect(subject.count).to eq(1)
      expect(subject.first.date).to  eq Time.parse('2013-01-01')
      expect(subject.first.open).to  eq(10.0)
      expect(subject.first.high).to  eq(20.0)
      expect(subject.first.low).to   eq(30.0)
      expect(subject.first.close).to eq(40.0)
      expect(subject.first.volume).to eq(1000)
    end

    it 'by hash' do
      expect(subject.count).to eq(0)
      subject << TechnicalAnalysis::Data::Candle.new(datetime: '2013-01-01', open:10, high:20, low:30, close:40, volume:1000)
      expect(subject.count).to eq(1)
      expect(subject.first.date).to  eq Time.parse('2013-01-01')
      expect(subject.first.open).to  eq(10.0)
      expect(subject.first.high).to  eq(20.0)
      expect(subject.first.low).to   eq(30.0)
      expect(subject.first.close).to eq(40.0)
      expect(subject.first.volume).to eq(1000)
    end

    it 'should only accept Hash, Array or Candle. An error should be raised' do
      expect { subject << 123 }.to raise_error('Candle parameters or Candle expected')
    end
  end
end
