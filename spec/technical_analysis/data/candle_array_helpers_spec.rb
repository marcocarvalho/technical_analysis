require 'spec_helper'

describe TechnicalAnalysis::Data::CandleArray do
  subject do 
    t = TechnicalAnalysis::Data::CandleArray.new
    require 'pry'; bundle.pry
    t.load_from_csv('spec/samples/small_petr4.csv')
    t
  end

  let(:sample_data) {
    [{ date: Time.parse('2013-03-26'), open: 18.73, high: 18.88, low: 18.48, close: 18.59, volume: 15781800 },
     { date: Time.parse('2013-03-25'), open: 18.73, high: 18.82, low: 18.42, close: 18.63, volume: 24340200 },
     { date: Time.parse('2013-03-22'), open: 18.55, high: 18.71, low: 18.46, close: 18.63, volume: 16137700 },
     { date: Time.parse('2013-03-21'), open: 18.72, high: 18.86, low: 18.49, close: 18.53, volume: 21978600 }]
  }

  context '#Helpers' do
    it '#high' do
      subject.high.should == sample_data.map { |i| i[:high] }
    end

    it '#low' do
      subject.low.should == sample_data.map { |i| i[:low] }
    end

    it '#low' do
      subject.open.should == sample_data.map { |i| i[:open] }
    end

    it '#low' do
      subject.close.should == sample_data.map { |i| i[:close] }
    end

    it '#low' do
      subject.volume.should == sample_data.map { |i| i[:volume] }
    end

    it '#low' do
      subject.date.should == sample_data.map { |i| i[:date] }
    end
  end
end