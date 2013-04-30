require 'spec_helper'

describe TechnicalAnalysis::RiskManagement::Classic do
  let(:portfolio) { Portfolio.new(cash: 10_000.0) }
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
    subject.quantity.should == 20 # portfolio.cash * max_loss / (trade_at - stop_loss)
  end

  it 'should calculate value by quantity' do
    subject.value.should == 10
  end
end