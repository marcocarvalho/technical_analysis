module TechnicalAnalysis::Data
  class Candle
    attr_accessor :open, :high, :low, :close, :volume

    def initialize(*vals)
      if vals.first.is_a?(Hash)
        update_attributes(vals.first)
      elsif not vals.empty?
        update_attributes(vals)
      end
    end

    def update_attributes(vals)
      raise ArgumentError.new('Hash or Array(open, high, low, close, volume) expected') unless [Hash, Array].include?(vals.class)
      if vals.is_a?(Array)
        @open, @high, @low, @close, @volume = vals
      elsif vals.is_a?(Hash)
        [:open, :high, :low, :close, :volume].each { |i| send("#{i}=", vals[i]) }
      end
    end
  end
end