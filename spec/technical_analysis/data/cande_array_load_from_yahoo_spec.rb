require 'spec_helper'

describe TechnicalAnalysis::Data::CandleArray do
  context '#loading Candles from yahoo' do
    it '#load' do
      expect(subject.count).to eq(0)
      subject.load_from_yahoo('petr4', start_date: '2013-03-18', end_date: '2013-03-22')
      expect(subject.count).to eq(5)
      expect(subject.period).to eq(:day)
      tests = [
          {:date=>Time.parse("2013-03-18"), :open=>18.90, :high=>19.35, :low=>18.84, :close=>19.20, :volume=>40451100, :adj_close=>"19.20"},
          {:date=>Time.parse("2013-03-19"), :open=>18.90, :high=>19.35, :low=>18.83, :close=>19.10, :volume=>33822900, :adj_close=>"19.10"}, 
          {:date=>Time.parse("2013-03-20"), :open=>19.05, :high=>19.16, :low=>18.68, :close=>18.85, :volume=>27636600, :adj_close=>"18.85"}, 
          {:date=>Time.parse("2013-03-21"), :open=>18.72, :high=>18.86, :low=>18.49, :close=>18.53, :volume=>21978600, :adj_close=>"18.53"}, 
          {:date=>Time.parse("2013-03-22"), :open=>18.55, :high=>18.71, :low=>18.46, :close=>18.63, :volume=>16137700, :adj_close=>"18.63"} 
        ]
      tests.each_index do |idx|
        tests[idx].each do |key, value|
          expect(subject[idx].send(key)).to eq(value) if subject[idx].respond_to?(key)
        end
      end
    end
  end
end
