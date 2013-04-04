module TechnicalAnalysis::Analysis
  module Pattern
    def support_resistence(array, signal, see_last = 2)
      raise ArgumentError.new('Array expected') unless array.is_a?(Array)
      raise ArgumentError.new('signal expected <, >, =>, etc') unless signal.is_a?(Symbol)
      sup = []
      array.each_index do |idx|
        next if idx < (see_last - 1)
        is_trend = true
        ((idx - see_last)..idx).each do |i|
          is_trend &= array[idx].send(signal, array[i])
        end
        sup << array[idx] if is_trend
      end
      sup
    end

    def supports(array, see_last = 2)
      support_resistence(array, :<, see_last)
    end

    def resistences(array, see_last = 2)
      support_resistence(array, :<, see_last)
    end
  end
end