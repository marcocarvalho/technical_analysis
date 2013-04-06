module TechnicalAnalysis::Analysis
  module Pattern
    def support_resistence(array, signal, see_last = 2)
      raise ArgumentError.new('Array expected') unless array.is_a?(Array)
      raise ArgumentError.new('signal expected <, >, =>, etc') unless signal.is_a?(Symbol)
      sup = []
      esig = (signal.to_s + '=').to_sym unless signal.to_s.index('=')
      array.each_index do |idx|
        next if idx < see_last
        is_trend = true
        ((idx - see_last)..(idx - 1)).each do |i|
          is_trend &= array[i].send(signal, array[idx])
        end
        if !array[idx + 1].nil?
          is_trend &= !array[idx].send(esig, array[(idx + 1)])
        else
          is_trend = false
        end
        if is_trend
          sup << array[idx]
        end
      end
      sup
    end

    def supports(see_last = 2)
      support_resistence(self.close, :>, see_last)
    end

    def resistences(see_last = 2)
      support_resistence(self.close, :<, see_last)
    end
  end
end