module TechnicalAnalysis::Data
  class CandleArray < Array
    attr_accessor :period

    include TechnicalAnalysis::Data::LoadInterfaces
    include TechnicalAnalysis::Data::Helpers
    include TechnicalAnalysis::Analysis::Trend
    include TechnicalAnalysis::Analysis::Pattern

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