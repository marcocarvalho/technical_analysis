require 'spec_helper'

describe TechnicalAnalysis::RunSetup do
  it '#risk_managements should be a list of classes' do
    subject.risk_management_list.map { |i| i.class }.uniq.should == [Class]
  end

  context '#run' do
    it 'should return false if cash is not number' do
      subject.run(nil, []).should be_false
    end

    it 'should return false if list is not an array' do
      subject.run(5000, nil).should be_false
    end
  end

  context '#risk_management_option_list' do
    it 'return empty hash if not a hash or empty one' do
      subject.risk_management_option_list({}).should  == {}
      subject.risk_management_option_list(nil).should == {}
    end

    it 'should mount all possible combinations beetween vars' do
      subject.risk_management_option_list(opt: [1,2,3], opt2: ['a', 'b']).should ==
        [{opt: 1, opt2: 'a'}, {opt: 1, opt2: 'b'},
          {opt: 2, opt2: 'a'}, {opt: 2, opt2: 'b'},
          {opt: 3, opt2: 'a'}, {opt: 3, opt2: 'b'} ]
    end

    it 'should mount all possible combinations even if there is only one' do
      subject.risk_management_option_list(opt: [1,2,3]).should ==
        [ {opt: 1}, {opt: 2}, {opt: 3} ]
    end
  end

  context '#risk_management' do
    it 'should create instances of risk_management with the product of options' do
      klass = mock(Class)
      klass.should_receive(:setup).and_return({o: [1,2]})
      klass.should_receive(:new).with({o:1}).and_return(1)
      klass.should_receive(:new).with({o:2}).and_return(2)
      subject.should_receive(:risk_management_list).and_return([klass])
      subject.should_receive(:risk_management_option_list).with(o: [1,2]).and_return([{o:1}, {o:2}])
      subject.risk_managements.should == [1,2]
    end
  end

  context '#entry_point_to_trade' do
    it 'shall transform entry_point to trade hash' do
      candle      = OpenStruct.new(date: :date)
      entry_point = { candle: candle, price_in: 10.1 }
      mr          = OpenStruct.new(quantity: 10)
      subject.entry_point     = entry_point
      subject.symbol          = 'symbol'
      subject.risk_management = mr
      subject.entry_point_to_trade.should == {
        price:    10.1,
        quantity: 10,
        date: :date,
        symbol: 'symbol',
        brokerage: 0
      }
    end
  end

  context '#where_clause' do
    it 'only symbol is given' do
      subject.where_clause('symbol').should == ['symbol = ?', 'symbol']
    end
    it 'ini date is given' do
      t = Time.new(2012, 10, 13)
      subject.should_receive(:start_date).exactly(2).times.and_return(t)
      subject.where_clause('symbol').should == ['symbol = ? and date >= ?', 'symbol', t]
    end
    it 'all parameters are passed' do
      t  = Time.new(2012, 10, 13)
      t2 = Time.new(2012, 10, 14)
      subject.should_receive(:start_date).exactly(2).times.and_return(t)
      subject.should_receive(:finish_date).exactly(2).times.and_return(t2)
      subject.where_clause('symbol').should == ['symbol = ? and date >= ? and date <= ?', 'symbol', t, t2]
    end
  end
end

# rs = RunSetup.new
# rs.run(5000, [papers...])
#  - get all Riskmanagement
#  - make all RiskManagement variations
#  - get all setups
#  Riskmanagement.each
#    riskmanagement.variations.each risk
#      setups.each setup
#        setup.entry_points.each do |entry|
#          trade! if risk.trade? entry
#        end
#      end
#    end