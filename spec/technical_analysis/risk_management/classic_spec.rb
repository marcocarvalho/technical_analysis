require 'spec_helper'

describe TechnicalAnalysis::RiskManagement::Classic do
  let(:cash) { 10_000.0 }
  let(:max) { 20.0 }
  let(:min) { 18.5 }
  let(:stop_loss) { max - ( (max - min) * 1.33 ) }
  let(:trade_at) { 19.1 }
  let(:max_loss) { 0.8 }

  it 'implement quantity_or_value?' do
    subject.quantity_or_value?.should == :quantity
  end

  it 'calc quantity' do
    subject.trade?(cash, trade_at, stop_loss: stop_loss).should be_true
    subject.quantity.should == 523 # 523 * 19.1 < 10_000
  end

  it 'should calculate value by quantity' do
    subject.trade?(cash, trade_at, stop_loss: stop_loss).should be_true
    subject.value.should == 523 * 19.1
  end

  it 'should return false if no price_in or cash or stop loss' do
    subject.trade?(nil, 10).should be_false
    subject.trade?(10, nil).should be_false
    subject.trade?(10,10, stop_loss: nil).should be_false
  end

  context 'small max loss to a grather cash' do
    let(:cash) { 250_000.0 }
    let(:max_loss) { 0.02 }
    it 'should ' do
      subject.trade?(cash, trade_at, stop_loss: stop_loss, max_loss: max_loss).should be_true
      subject.quantity.should == 4566
      subject.value.should == 4566 * 19.1
    end
  end

  context 'no cash left' do
    let(:cash) { 10 }
    it 'should have no trade!' do
      subject.trade?(cash, trade_at, stop_loss: stop_loss, max_loss: max_loss).should be_false
    end
  end
end