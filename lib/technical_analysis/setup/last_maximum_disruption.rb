module TechnicalAnalysis
  class LastMaximumDisruption < Setup
    def trade?(price, idx = nil)
      if idx
        candle_array[idx].high < price
      else
        candle_array.last.high < price
      end
    end

    def stop_loss(idx = nil)
      if idx
        candle_array[idx].low
      else
        candle_array.last.low
      end
    end

    def stop_gain(idx = nil)
      if idx
        candle_array[idx].high * 1.07
      else
        candle_array.last.high * 1.07
      end
    end

    def search_all
      candle_array.each_index do |idx|
        next if idx == 0
        last = candle_array[idx - 1].high
        now  = candle_array[idx].high
        if last < now
          { stop_gain: stop_gain(idx), stop_loss: stop_loss(idx),  }
        end
      end
    end
  end
end