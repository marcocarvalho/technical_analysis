module TechnicalAnalysis::Analysis
  module Indicator
    # Probaly this is wrong!
    def hilo(minimun = 3)
      cl = close
      return [] if cl.size < 4
      sma_high = sma(3, :high)
      sma_low  = sma(3, :low)
      cl = cl[2..cl.size]
      gann = []

      cl.each_index do |idx|
        next if cl[idx + 1].nil?
        if cl[idx] < sma_low[idx]
          gann << sma_high[idx]
        else
          gann << sma_low[idx]
        end         
      end
      gann
    end
  end
end
