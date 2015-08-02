require 'spec_helper'

describe TechnicalAnalysis::Data::CandleArray do
  subject do 
    t = TechnicalAnalysis::Data::CandleArray.new
    t.load_from_csv('spec/samples/small_petr4.csv')
    t
  end

  let(:sample_data) {
    [
     { date: Time.parse('2013-03-21'), open: 18.72, high: 18.86, low: 18.49, close: 18.53, volume: 21978600 },
     { date: Time.parse('2013-03-22'), open: 18.55, high: 18.71, low: 18.46, close: 18.63, volume: 16137700 },
     { date: Time.parse('2013-03-25'), open: 18.73, high: 18.82, low: 18.42, close: 18.63, volume: 24340200 },
     { date: Time.parse('2013-03-26'), open: 18.73, high: 18.88, low: 18.48, close: 18.59, volume: 15781800 }
   ]
  }

  context '#Helpers' do
    it '#high' do
      expect(subject.high).to eq sample_data.map { |i| i[:high] }
    end

    it '#low' do
      expect(subject.low).to eq sample_data.map { |i| i[:low] }
    end

    it '#open' do
      expect(subject.open).to eq sample_data.map { |i| i[:open] }
    end

    it '#low' do
      expect(subject.close).to eq sample_data.map { |i| i[:close] }
    end

    it '#volume' do
      expect(subject.volume).to eq sample_data.map { |i| i[:volume] }
    end

    it '#date' do
      expect(subject.date).to eq sample_data.map { |i| i[:date] }
    end

    it '#stop_loss with last' do
      high = subject.last.high
      low  = subject.last.low
      expect(subject.stop_loss).to eq ( high - ( ( high - low ) * 1.33 ) ) 
    end
  end
end
