module TechnicalAnalysis::Analysis
  module Indicator
    def sma(time, part = :close)
      send(part).sma(time)
    end
  end
end
