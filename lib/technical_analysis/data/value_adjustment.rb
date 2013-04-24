module TechnicalAnalysis::Data
  class ValueAdjustment
    attr_reader   :symbol, :date_in, :price_in, :quantity, :date_out, :money_in
    attr_accessor :change
    def initialize(sym, dt_in, opts = {})
      options = {
        price_in: :close,
        quantity: :default,
        money_in: 0
        }.merge(opts)

      self.date_out = options[:date_out]
      self.date_in  = dt_in
      self.symbol   = sym
      self.price_in = options[:price_in]
      self.money_in = options[:money_in]
      self.quantity = options[:quantity]
      self.change   = 0
    end

    def quantity=(v)
      if v == :default and money_in == 0
        # take default lote qtd. for now 100 will be fine
        @quantity = 100
      elsif v == :default and money_in > 0
        self.change = 
      else
        @quantity = v.to_i
      end
    end

    def date_in=(d)
      @date_in = parse_date(d)
    end

    def date_out=(d)
      @date_out = parse_date(d)
    end

    def symbol=(s)
      raise 'Symbol must be present' if s.to_s.empty?
      @symbol = s
    end

    def company=(c)
      if c.is_a?(Company)
        @company = c
      else
        raise 'Company model expected'
      end
    end

    def company
      @company ||= Company.where(symbol).first
    end

    def historical_quote
      return @historical_quote if @historical_quote.is_a?(HistoricalQuote)
      @historical_quote = HistoricalQuote.where(symbol: symbol, date: date_in).first
      raise "No historical quote for symbol #{symbol} in #{date_in}" if @historical_quote.nil?
      @historical_quote
    end

    def price_in=(v)
      return @price_in if @price_in.is_a?(Float)
      if v.kind_of?(Numeric) or v.is_a?(String)
        @price_in = v.to_f
      elsif v.is_a? Symbol
        @price_in = parse_price_in(v)
      end
    end

    def parse_price_in(v)
      if [:open, :high, :low, :close].include?(v)
        historical_quote.send(v)
      elsif v.to_s =~ /(near|above|below)_(.+)/
        cmd = $1.to_sym
        val = 1
      else
        0
      end
    end

    def parse_date(d)
      if d.is_a?(String)
        return Time.parse(d)
      elsif d.is_a?(Date) or d.is_a?(Time) or d.is_a?(DateTime)
        return d
      else
        raise 'parsable date/time or Time, Date, DateTime objects is needed'
      end      
    end
  end
end