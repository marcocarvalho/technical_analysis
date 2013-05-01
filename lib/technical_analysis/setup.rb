#
module TechnicalAnalysis
  class Setup
    attr_accessor :options, :candle_array
    def self.inherited(klass)
      @klasses ||= []
      @klasses << klass
    end

    def initialize(candle_arr, opts = {})
      @options      = opts
      @candle_array = candle_arr
    end

    def index(reindex = false)
      return @index if @index.is_a?(Hash) and reindex == false
      @index = {}
      @candle_array.each_index do |idx|
        i = @candle_array[idx]
        @index[i.date] = idx
      end
      @index
    end
  end
end