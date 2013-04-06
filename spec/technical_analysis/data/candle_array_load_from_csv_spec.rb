require 'spec_helper'

describe TechnicalAnalysis::Data::CandleArray do
  context '#loading Candles from csv' do
    it '#load' do
      subject.count.should be(0)
      subject.load_from_csv(File.join(File.dirname(__FILE__), 'sample.csv'))
      subject.count.should be(4)
      subject.period.should be(:day)
      tests = [
              { date: Time.parse('2013-03-21'), open: 18.72, high: 18.86, low: 18.49, close: 18.53, volume: 21978600 },
              { date: Time.parse('2013-03-22'), open: 18.55, high: 18.71, low: 18.46, close: 18.63, volume: 16137700 },
              { date: Time.parse('2013-03-25'), open: 18.73, high: 18.82, low: 18.42, close: 18.63, volume: 24340200 },
              { date: Time.parse('2013-03-26'), open: 18.73, high: 18.88, low: 18.48, close: 18.59, volume: 15781800 }
            ]
      tests.each_index do |idx|
        tests[idx].each do |key, value|
          expect(subject[idx].send(key)).to eq(value)
        end
      end
    end
  end
end