require 'spec_helper'

describe TechnicalAnalysis::LastMaximumDisruption do
  it 'should get signal for each entry point' do
    expect(subject).to receive(:range).and_return([1,2,3,4])
    expect(subject).to receive(:entry_point?).exactly(4).times.and_return(true, false, true, false)
    expect(subject).to receive(:signal).exactly(2).times.and_return(1)

    expect(subject.run_setup).to eq [1, 1]
  end

  context '#candle' do
    subject { TechnicalAnalysis::LastMaximumDisruption.new candle_array: [:one_item_only] }
    it 'Should return nil when index does not match item' do
      expect(subject.candle(1)).to be_nil
    end

    it 'Should return the item if no attribute name given' do
      expect(subject.candle(0)).to eq :one_item_only
    end

    context '' do
      let(:candle) { double(:candle) }

      subject { TechnicalAnalysis::LastMaximumDisruption.new candle_array: [candle] }

      before(:each) do
        expect(candle).to receive(:my_fancy_attribute)
          .once
          .and_return(:value)
      end

      it 'Should return the attribute value for the given attribute name' do
        expect(subject.candle(0, :my_fancy_attribute)).to eq :value
      end
    end
  end

  context '#trade?' do
    before(:each) do
      allow(subject).to receive(:candle)
        .once
        .with(-1, :high)
        .and_return(200)
    end

    it{ expect(subject.trade?(100)).to be(false) }
    it{ expect(subject.trade?(300)).to be(true) }
  end

  context '#stop_loss' do
    it 'Should get the rounded by 2 value of low' do
      low = double(:low)
      expect(low).to receive(:round).once.with(2).and_return(:rounded_by_2)

      allow(subject).to receive(:candle)
        .once
        .with(:idx, :low)
        .and_return(low)

      expect(subject.stop_loss(:idx)).to eq :rounded_by_2
    end
  end

  context '#stop_gain' do
    before(:each) do
      expect(subject).to receive(:candle)
        .once
        .with(:idx, :high)
        .and_return(1.111)
    end

    it 'Should apply target and round by 2 value of high' do
      expect(subject.stop_gain(:idx, 5)).to eq 5.56
    end

    it 'Should use a default target of 1.07' do
      expect(subject.stop_gain(:idx)).to eq 1.19
    end
  end

  context '#entry_point?' do
    def try_entry(opts = {})
      expect(subject).to receive(:candle)
        .once
        .with(-1, :high)
        .and_return(opts[:yesterday_high])
      expect(subject).to receive(:candle)
        .once
        .with(0, :high)
        .and_return(opts[:today_high])

      subject.entry_point?(0)
    end

    it 'Should return true if todays high is bigger than yesterdays' do
      expect(try_entry(yesterday_high: 100, today_high: 200)).to be(true)
    end

    it 'Should return false if yesterdays high is bigger than todays' do
      expect(try_entry(yesterday_high: 200, today_high: 100)).to be(false)
    end

    it 'Should return false if today and yesterday high are equal' do
      expect(try_entry(yesterday_high: 100, today_high: 100)).to be(false)
    end

  end

  context '#signal' do
    it 'Should mount signal' do
      allow(subject).to receive(:candle).with(:idx).and_return(:actual_candle)
      allow(subject).to receive(:stop_loss).with(:idx).and_return(:stop_loss)
      allow(subject).to receive(:stop_gain).with(:idx).and_return(:stop_gain)
      allow(subject).to receive(:price_in).with(:idx).and_return(:price_in)
      expect(subject.signal(:idx)).to eq({ idx: :idx, price_in: :price_in, candle: :actual_candle, stop_gain: :stop_gain, stop_loss: :stop_loss })
    end
  end

  context '#range' do
    it 'Should return empty array unless minimal ticks' do
      allow(subject).to receive(:mininal_ticks?).once.and_return(false)
      expect(subject.range).to eq []
    end

    it 'Should return the range if have minimal ticks' do
      allow(subject).to receive(:mininal_ticks?).once.and_return(true)
      allow(subject).to receive(:candle_array).once.and_return(Array.new(10))
      expect(subject.range).to eq (1..9)
    end
  end

end
