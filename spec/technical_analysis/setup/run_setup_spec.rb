require 'spec_helper'

describe TechnicalAnalysis::RunSetup do
  it '#risk_managements should be a list of classes' do
    expect(subject.risk_management_list.map { |i| i.class }.uniq).to eq [Class]
  end

  context '#run' do
    it 'should return false if cash is not number' do
      expect(subject.run(nil, [])).to be(false)
    end

    it 'should return false if list is not an array' do
      expect(subject.run(5000, nil)).to be(false)
    end
  end

  context '#risk_management_option_list' do
    it 'return empty hash if not a hash or empty one' do
      expect(subject.risk_management_option_list({})).to  eq( {})
      expect(subject.risk_management_option_list(nil)).to eq( {})
    end

    it 'should mount all possible combinations beetween vars' do
      expect(subject.risk_management_option_list(opt: [1,2,3], opt2: ['a', 'b'])).to eq(
        [{opt: 1, opt2: 'a'}, {opt: 1, opt2: 'b'},
          {opt: 2, opt2: 'a'}, {opt: 2, opt2: 'b'},
          {opt: 3, opt2: 'a'}, {opt: 3, opt2: 'b'} ]
      )
    end

    it 'should mount all possible combinations even if there is only one' do
      expect(subject.risk_management_option_list(opt: [1,2,3])).to eq(
        [ {opt: 1}, {opt: 2}, {opt: 3} ]
      )
    end
  end

  context '#risk_management' do
    it 'should create instances of risk_management with the product of options' do
      klass = double(Class)
      expect(klass).to receive(:setup).and_return({o: [1,2]})
      expect(klass).to receive(:new).with({o:1}).and_return(1)
      expect(klass).to receive(:new).with({o:2}).and_return(2)
      expect(subject).to receive(:risk_management_list).and_return([klass])
      expect(subject).to receive(:risk_management_option_list).with(o: [1,2]).and_return([{o:1}, {o:2}])
      expect(subject.risk_managements).to eq [1,2]
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
      expect(subject.entry_point_to_trade).to eq({
        price:    10.1,
        quantity: 10,
        date: :date,
        symbol: 'symbol',
        brokerage: 0
      })
    end
  end

  context '#where_clause' do
    it 'only symbol is given' do
      expect(subject.where_clause('symbol')).to eq ['symbol = ?', 'symbol']
    end
    it 'ini date is given' do
      t = Time.new(2012, 10, 13)
      expect(subject).to receive(:start_date).exactly(2).times.and_return(t)
      expect(subject.where_clause('symbol')).to eq ['symbol = ? and date >= ?', 'symbol', t]
    end
    it 'all parameters are passed' do
      t  = Time.new(2012, 10, 13)
      t2 = Time.new(2012, 10, 14)
      expect(subject).to receive(:start_date).exactly(2).times.and_return(t)
      expect(subject).to receive(:finish_date).exactly(2).times.and_return(t2)
      expect(subject.where_clause('symbol')).to eq ['symbol = ? and date >= ? and date <= ?', 'symbol', t, t2]
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
