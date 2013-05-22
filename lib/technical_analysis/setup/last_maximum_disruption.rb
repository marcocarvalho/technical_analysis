module TechnicalAnalysis
  # @todo Explain this class :)
  class LastMaximumDisruption < Setup
    # Returns a candle or the value of a candel inside candle_array
    #
    # @param [Fixnum] idx candle position
    # @param [Symbol] attribute attribute name to read from the candle
    # @return [Candle, Object] the candle itself or the selected attribute
    #
    # @example Retrieving the candle itself
    #    candle(0)
    #    candle(-1)
    #
    # @example Retrieving candle properties
    #    candle(2, :close)
    #    candle(0, :high)
    #
    # @see TechnicalAnalysis::Data::Candle
    def candle(idx, attribute = nil)
      cdl = candle_array[idx]
      return cdl if cdl.nil? or attribute.nil?
      cdl.send attribute
    end

    # Verifies if a trade is possible
    #
    # @param [Number] price matching price
    # @param [Fixnum] idx candle position
    # @return [TrueClass, FalseClass] true if can trade
    def trade?(price, idx = -1)
      candle(idx, :high) < price
    end

    # Stop loss
    #
    # @param [Fixnum] idx candle position
    # @return [Float] stop loss
    def stop_loss(idx)
      candle(idx, :low).round(2)
    end

    # Stop gain
    #
    # @param [Fixnum] idx candle position
    # @param [Float] target target value in percentual (7% ~> 1.07)
    # @return [Float] stop gain
    def stop_gain(idx, target = 1.07)
      (candle(idx, :high) * target).round(2)
    end

    # Checks if it is an entry point
    #
    # @param [Fixnum] idx candle position
    # @return [TrueClass, FalseClass] true if it is an entry point
    def entry_point?(idx)
      candle(idx - 1, :high) < candle(idx, :high)
    end

    # Generates a signal
    #
    # @param [Fixnum] idx candle position
    # @return [Hash] signal hash with keys :candle, :stop_gain and :stop_loss
    #
    # @todo Explain better what is a signal and its use
    def signal(idx)
      { candle: candle(idx), stop_gain: stop_gain(idx), stop_loss: stop_loss(idx) }
    end

    # Computes a processing range
    # @return [Range] processing range
    # @todo Explain better the need and usage of range
    def range
      return [] unless mininal_ticks?
      (1..(candle_array.size - 1))
    end

    # Run the setup
    #
    # @return [Array] array of signals for the candle array
    def run_setup
      range.map { |idx| signal(idx) if entry_point?(idx) }.compact
    end
  end
end
