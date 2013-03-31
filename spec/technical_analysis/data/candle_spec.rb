require 'spec_helper'

describe TechnicalAnalysis::Data::Candle do
  let(:params) { [] }
  subject { TechnicalAnalysis::Data::Candle.new(*params) }
  it 'should initialize without parameters' do
    subject.open.should be_nil
    subject.high.should be_nil
    subject.low.should be_nil
    subject.close.should be_nil
    subject.volume.should be_nil
  end

  context 'Array as params' do
    let(:params) { [10,20,30,40,1000] }
    it 'should initialize candle' do
      subject.open.should be(10)
      subject.high.should be(20)
      subject.low.should be(30)
      subject.close.should be(40)
      subject.volume.should be(1000)
    end
  end

  context 'Array missing some last parameters' do
    let(:params) { [10,20,30] }
    it 'should initialize candle' do
      subject.open.should be(10)
      subject.high.should be(20)
      subject.low.should be(30)
      subject.close.should be_nil
      subject.volume.should be_nil
    end
  end

  context 'Hash initialize' do
    let(:params) { [{open: 10, high: 20, low: 30, close: 40, volume: 1000, bugabu: 'xxxx'}] }
    it 'shoudl initialize candle and ignore unknow parameters' do
      subject.open.should be(10)
      subject.high.should be(20)
      subject.low.should be(30)
      subject.close.should be(40)
      subject.volume.should be(1000)
    end
  end

  context 'Hash initialize with missing parameters' do
    let(:params) { [{open: 10, high: 20, low: 30, bugabu: 'xxxx'}] }
    it 'shoudl initialize candle and ignore unknow parameters' do
      subject.open.should be(10)
      subject.high.should be(20)
      subject.low.should be(30)
      subject.close.should be_nil
      subject.volume.should be_nil
    end
  end
end