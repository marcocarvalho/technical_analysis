require 'spec_helper'

describe TechnicalAnalysis::Data::Candle do
  let(:params) { [] }
  subject { TechnicalAnalysis::Data::Candle.new(*params) }
  it 'should initialize without parameters' do
    subject.datetime.should be_nil
    subject.open.should be_nil
    subject.high.should be_nil
    subject.low.should be_nil
    subject.close.should be_nil
    subject.volume.should be_nil
  end

  context 'Array as params' do
    let(:params) { ['2012-10-10', 10, 20,30,40,1000] }
    it 'should initialize candle' do
      subject.date.should == Time.parse('2012-10-10')
      subject.open.should be(10.0)
      subject.high.should be(20.0)
      subject.low.should be(30.0)
      subject.close.should be(40.0)
      subject.volume.should be(1000)
    end
  end

  context 'methods included' do
    let(:params) { ['2012-10-10', 20, 30, 20, 30,1000] }
    it 'stop_loss' do
      subject.stop_loss.should == ( 30 - ( ( 30 - 20 ) * 1.33 ) )
    end
  end

  context 'Array missing some last parameters' do
    let(:params) { ['2012-10-10',10,20,'30'] }
    it 'should initialize candle' do
      subject.time.should == Time.parse('2012-10-10')
      subject.open.should be(10.0)
      subject.high.should be(20.0)
      subject.low.should be(30.0)
      subject.close.should be_nil
      subject.volume.should be_nil
    end
  end

  context 'Hash initialize' do
    let(:params) { [{date: '2012-10-10', open: 10, high: '20', low: 30, close: 40, volume: 1000.0, bugabu: 'xxxx'}] }
    it 'shoudl initialize candle and ignore unknow parameters' do
      subject.datetime.should == Time.parse('2012-10-10')
      subject.open.should be(10.0)
      subject.high.should be(20.0)
      subject.low.should be(30.0)
      subject.close.should be(40.0)
      subject.volume.should be(1000)
    end
  end

  context 'Corrections' do
    let(:params) { [{date: '2012-10-10', open: 10, high: '20', low: 30, close: 40, volume: 1000.0}] }
    it 'shoudl initialize candle and ignore unknow parameters' do
      subject.apply_factor(2)
      subject.open.should == 20.0
      subject.high.should == 40.0
      subject.low.should == 60.0
      subject.close.should == 80.0
      subject.volume.should == 2000.0
    end

    it 'should apply faction of factors' do
      subject.apply_factor('0.5')
      subject.open.should   == 5.0
      subject.high.should   == 10.0
      subject.low.should    == 15.0
      subject.close.should  == 20.0
      subject.volume.should == 500.0
    end

    context '#quote model' do
      let(:params) { { date: '2012-10-10', open: 10, high: 20, low: 30, close: 40, volume: 1000 } }
      subject { Quote.new(params) }
      it '#apply_factor' do
        subject.apply_factor('0.5')
        subject.open.should   == 5.0
        subject.high.should   == 10.0
        subject.low.should    == 15.0
        subject.close.should  == 20.0
        subject.volume.should == 500.0
      end
    end

    context '#quote model' do
      let(:params) { { date: '2012-10-10', open: 10, high: 20, low: 30, close: 40, volume: 1000 } }
      subject { HistoricalQuote.new(params) }
      it '#apply_factor' do
        subject.apply_factor('0.5')
        subject.open.should   == 5.0
        subject.high.should   == 10.0
        subject.low.should    == 15.0
        subject.close.should  == 20.0
        subject.volume.should == 500.0
      end
    end
  end

  context 'Hash initialize with missing parameters' do
    let(:params) { [{time: '2012-10-10', open: 10, high: 20, low: 30, bugabu: 'xxxx'}] }
    it 'shoudl initialize candle and ignore unknow parameters' do
      subject.date.should == Time.parse('2012-10-10')
      subject.open.should be(10.0)
      subject.high.should be(20.0)
      subject.low.should be(30.0)
      subject.close.should be_nil
      subject.volume.should be_nil
    end
  end
end