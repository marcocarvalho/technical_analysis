module TechnicalAnalysis::Data
  class CandleArray < Array
    def <<(val)
      if val.is_a?(Hash)
        super(Candle.new(val))
      elsif val.is_a?(Array)
        super(Candle.new(*val))
      elsif val.is_a?(Candle)
        super(val)
      else
        raise ArgumentError.new('Candle parameters or Candle expected')
      end
    end
  end
end