require 'spec_helper'

describe TechnicalAnalysis::RiskManagement::Classic do
  let(:cash) { 10_000.0 }
  let(:portfolio) { Portfolio.new(cash: cash) }
  let(:max) { 20.0 }
  let(:min) { 18.5 }
  let(:stop_loss) { max - ( (max - min) * 1.33 ) }
  let(:trade_at) { 19.1 }
  let(:max_loss) { 0.8 }
  subject { TechnicalAnalysis::RiskManagement::Classic.new(portfolio, stop_loss: stop_loss, trade_at: trade_at, max_loss: max_loss) }

  it 'implement quantity_or_value?' do
    subject.quantity_or_value?.should == :quantity
  end

  it 'calc quantity' do
    subject.quantity.should == 523 # 523 * 19.1 < 10_000
  end

  it 'should calculate value by quantity' do
    subject.value.should be <= portfolio.cash
    subject.value.should == 523 * 19.1
  end

  context 'small max loss to a grather cash' do
    let(:cash) { 250_000.0 }
    let(:max_loss) { 0.02 }
    it 'should ' do
      subject.quantity.should == 4566
      subject.value.should == 4566 * 19.1
    end
  end
end