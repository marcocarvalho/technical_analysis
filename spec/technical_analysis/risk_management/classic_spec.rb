require 'spec_helper'

describe TechnicalAnalysis::RiskManagement::Classic do
  let(:cash) { 10_000.0 }
  let(:max) { 20.0 }
  let(:min) { 18.5 }
  let(:stop_loss) { max - ( (max - min) * 1.33 ) }
  let(:trade_at) { 19.1 }
  let(:max_loss) { 0.8 }

  it 'implement quantity_or_value?' do
    expect(subject.quantity_or_value?).to eq :quantity
  end

  it 'calc quantity' do
    expect(subject.trade?(cash, trade_at, stop_loss: stop_loss)).to be(true)
    expect(subject.quantity).to eq 523 # 523 * 19.1 < 10_000
  end

  it 'should calculate value by quantity' do
    expect(subject.trade?(cash, trade_at, stop_loss: stop_loss)).to be(true)
    expect(subject.value).to eq 523 * 19.1
  end

  it 'should return false if no price_in or cash or stop loss' do
    expect(subject.trade?(nil, 10)).to be(false)
    expect(subject.trade?(10, nil)).to be(false)
    expect(subject.trade?(10,10, stop_loss: nil)).to be(false)
  end

  context 'small max loss to a grather cash' do
    let(:cash) { 250_000.0 }
    let(:max_loss) { 0.02 }
    it 'should ' do
      expect(subject.trade?(cash, trade_at, stop_loss: stop_loss, max_loss: max_loss)).to be(true)
      expect(subject.quantity).to eq 4566
      expect(subject.value).to eq 4566 * 19.1
    end
  end

  context 'no cash left' do
    let(:cash) { 10 }
    it 'should have no trade!' do
      expect(subject.trade?(cash, trade_at, stop_loss: stop_loss, max_loss: max_loss)).to be(false)
    end
  end
end
