module TechnicalAnalysis
  class LastMaximumDisruption < Setup
    def trade?(price, idx)
      candle_array[idx].high < price
    end

    def stop_loss(idx)
      candle_array[idx].low.round(2)
    end

    def stop_gain(idx)
      (candle_array[idx].high * 1.07).round(2)
    end

    def entry_point?(idx)
      candle_array[idx - 1].high < candle_array[idx].high
    end

    def signal(idx)
      { candle: candle_array[idx], stop_gain: stop_gain(idx), stop_loss: stop_loss(idx) }
    end

    def range
      (1..(candle_array.size - 1))
    end

    def run_setup
      ret = []
      return ret if minimal_ticks?
      range.each do |idx|
        ret << signal(idx) if entry_point?(idx)
      end
      ret
    end
  end
end