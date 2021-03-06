module TechnicalAnalysis::Data
  class ValueAdjustment
    include TechnicalAnalysis::Data::Helpers
    attr_writer   :symbol, :date_in, :price_in, :quantity, :date_out
    attr_accessor :change, :price_tolerance, :money_in
    def initialize(sym, dt_in, opts = {})
      options = {
        price_in: :close,
        quantity: :default,
        money_in: 0,
        price_tolerance: 0.1
        }.merge(opts)

      @date_out        = options[:date_out]
      @date_in         = dt_in
      @symbol          = sym
      @price_in        = options[:price_in]
      @money_in        = options[:money_in]
      @quantity        = options[:quantity]
      @price_tolerance = options[:price_tolerance]
      @change          = 0
      @parsed          = {}
    end

    def value_at(date)
      h = historical_quote_at(date)
      movs = company.movements.where('ex_at <= ? and ex_at > ?', date, date_in)
      divs = company.dividents.where('ex_at <= ? and ex_at > ?', date, date_in)

    end

    def quantity_at(date)

    end

    def parsed?(field)
      @parsed[field]
    end

    def quantity
      return @quantity if parsed?(__method__)
      if @quantity == :default and money_in == 0
        # take default lote qtd. for now 100 will be fine
        @quantity = 100
      elsif @quantity == :default and money_in > 0
        # change to lote padrão em implemented
        @change += money_in % 100
        @quantity = money_in / 100
        # calculate by money_in
      else
        @quantity = @quantity.to_i
      end
      @parsed[:quantity] = true
      @quantity
    end

    def date_in
      return @date_in if parsed?(__method__)
      @date_in = parse_date(@date_in)
      @parsed[__method__] = true
      @date_in
    end

    def date_out
      return @date_out if parsed?(__method__)
      @date_out = parse_date(@date_out)
      @parsed[__method__] = true
      @date_out
    end

    def symbol
      raise 'Symbol must be present' if @symbol.to_s.empty?
      @symbol
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

    def historical_quote_at(date)
      HistoricalQuote.where(symbol: symbol, date: date).first
    end

    def price_in
      return @price_in if parsed?(__method__)
      if @price_in.kind_of?(Numeric) or v.is_a?(String)
        @price_in = @price_in.to_f
      elsif @price_in.is_a? Symbol
        @price_in = parse_price_in(@price_in)
      end
      @parsed[__method__] = true
      @price_in
    end

    def parse_price_in(v)
      if [:open, :high, :low, :close, :volume].include?(v)
        historical_quote.send(v)
      elsif v.to_s =~ /(near|above|below)_(.+)/
        cmd = $2.to_sym
        if [:open, :high, :low, :close].include?(cmd)
          send("price_#{$1}", cmd)
        else
          0
        end
      else
        0
      end
    end

    def price_near(candle_notation_price)
      super(historical_quote, candle_notation_price, price_tolerance: price_tolerance)
    end

    def price_above(candle_notation_price)
      super(historical_quote, candle_notation_price)
    end

    def price_below(candle_notation_price)
      super(historical_quote, candle_notation_price)
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