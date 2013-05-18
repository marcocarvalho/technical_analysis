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
        candle_array[idx].low.round(2)
      else
        candle_array.last.low.round(2)
      end
    end

    def stop_gain(idx = nil)
      if idx
        (candle_array[idx].high * 1.07).round(2)
      else
        (candle_array.last.high * 1.07).round(2)
      end
    end

    def entry_point?(idx = nil)
      if idx
        candle_array[idx - 1].high < candle_array[idx].high
      else
        candle_array[-2].high < candle_array[-1].high
      end
    end

    minimal_ticks?

    def run_setup
      ret = []
      return ret if minimal_ticks?
      candle_array.each_index do |idx|
        next if idx == 0
        if entry_point?(idx)
          signal = { candle: candle_array[idx], stop_gain: stop_gain(idx), stop_loss: stop_loss(idx) }
          ret << signal
        end
      end
      ret
    end
  end
end