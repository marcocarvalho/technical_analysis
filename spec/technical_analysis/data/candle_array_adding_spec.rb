require 'spec_helper'

describe TechnicalAnalysis::Data::CandleArray do
  context '#adding Candles' do
    it 'by array' do
      subject.count.should be(0)
      subject << [10,20,30,40,1000]
      subject.count.should be(1)
      subject.first.open.should  be(10)
      subject.first.high.should  be(20)
      subject.first.low.should   be(30)
      subject.first.close.should be(40)
      subject.first.volume.should be(1000)
    end

    it 'by hash' do
      subject.count.should be(0)
      subject << { open:10, high:20, low:30, close:40, volume:1000 }
      subject.count.should be(1)
      subject.first.open.should  be(10)
      subject.first.high.should  be(20)
      subject.first.low.should   be(30)
      subject.first.close.should be(40)
      subject.first.volume.should be(1000)
    end

    it 'by hash' do
      subject.count.should be(0)
      subject << TechnicalAnalysis::Data::Candle.new(open:10, high:20, low:30, close:40, volume:1000)
      subject.count.should be(1)
      subject.first.open.should  be(10)
      subject.first.high.should  be(20)
      subject.first.low.should   be(30)
      subject.first.close.should be(40)
      subject.first.volume.should be(1000)
    end

    it 'should only accept Hash, Array or Candle. An error should be raised' do
      expect { subject << 123 }.to raise_error('Candle parameters or Candle expected')
    end
  end
end