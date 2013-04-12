module TechnicalAnalysis::Data::LoadInterfaces
  module ClassMethods
    def load_from_yahoo(symbol, options = {})
      s = self.new
      s.load_from_csv(filename, options)
      s
    end
  end

private
  def yahoo_parse_date(opt, key, default_time = 1)
    if(opt.include?(key))
      if opt[key].is_a?(String)
        opt[key] = Date.parse(opt[key])
      elsif opt[key].is_a?(Time)
        opt[key] = opt[key].to_date
      elsif opt[key].is_a?(Date)
        #just ok
      else
        raise ArgumentError.new("#{key} must be Time, Date or parseble date/time string")
      end
    else
      opt[key] = Date.today - default_time
    end
    opt
  end
public

  def load_from_yahoo(symbol, options = {})
    opt = { period: :day, last_days: 30 }.merge(options)

    self.symbol = symbol
    symbol      = symbol.to_s.downcase + '.sa'
    self.period = opt[:period]
    
    yahoo_parse_date(opt, :start_date, 1)
    yahoo_parse_date(opt, :end_date, opt[:last_days])

    history = YahooStock::History.new(:stock_symbol => symbol, :start_date => opt[:start_date], :end_date => opt[:end_date])
    history.results(:to_hash).output.each do |h|
      self << h
    end
    self.sort! { |a,b| a.date <=> b.date }
  end
end