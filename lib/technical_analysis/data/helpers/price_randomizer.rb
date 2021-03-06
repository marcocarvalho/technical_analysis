module TechnicalAnalysis::Data
  module Helpers
    def price_between(v1, v2)
      seed = SecureRandom.random_number
      ((v2 - v1) * seed) + v1
    end

    def price_near(candle, candle_notation_price, opts = { })
      opts = { price_tolerance: 0.1 }.merge opts
      price = candle.send(candle_notation_price)
      tolerance = price * opts[:price_tolerance]
      seed = SecureRandom.random_number

      (((tolerance * 2) * seed) + (price - tolerance)).round(2)
    end

    def price_above(candle, candle_notation_price, opts = {})
      raise ArgumentError.new 'high cannot be used in this method' if candle_notation_price == :high
      high     = candle.high
      price_at = candle.send(candle_notation_price)
      ((high - price_at) * SecureRandom.random_number) + price_at
    end

    def price_below(candle, candle_notation_price, opts = {})
      raise ArgumentError.new 'low cannot be used in this method' if candle_notation_price == :low
      low      = candle.low
      price_at = candle.send(candle_notation_price)
      ((price_at - low) * SecureRandom.random_number) + low
    end
  end
end