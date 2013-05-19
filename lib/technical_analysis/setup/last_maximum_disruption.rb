module TechnicalAnalysis
  class LastMaximumDisruption < Setup
    def candle(idx, attribute = nil)
      cdl = candle_array[idx]
      return cdl if cdl.nil? or attribute.nil?
      cdl.send attribute
    end

    def trade?(price, idx = -1)
      candle(idx, :high) < price
    end

    def stop_loss(idx)
      candle(idx, :low).round(2)
    end

    def stop_gain(idx, target = 1.07)
      (candle(idx, :high) * target).round(2)
    end

    def entry_point?(idx)
      candle(idx - 1, :high) < candle(idx, :high)
    end

    def signal(idx)
      { candle: candle(idx), stop_gain: stop_gain(idx), stop_loss: stop_loss(idx) }
    end

    def range
      if minimal_ticks?
        (1..(candle_array.size - 1))
      else
        []
      end
    end

    def run_setup
      range.map { |idx| signal(idx) if entry_point?(idx) }.compact
    end
  end
end
