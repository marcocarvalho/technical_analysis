module TechnicalAnalysis
  class LastMaximumDisruption < Setup
    def trade?(price)
      candle_array.last.high < price
    end

    def stop_loss
      candle_array.last.low
    end

    def stop_gain
      candle_array.last.high * 1.07
    end
  end
end