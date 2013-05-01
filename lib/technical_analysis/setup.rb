#
module TechnicalAnalysis
  class Setup
    attr_accessor :options, :candle_array
    def self.inherited(klass)
      @klasses ||= []
      @klasses << klass
    end

    def self.all
      @klasses ||= []
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

    def start_at(date_or_pos = nil)
      parse_date_or_position(date_or_pos || options[:start_at]) || 0
    end

    def end_at(date_or_pos = nil)
      parse_date_or_position(date_or_pos || options[:end_at]) || (candle_array.count - 1)
    end

    private
    def parse_date_or_position(val)
      if val.is_a?(Time)
        index[val]
      elsif val.is_a?(String)
        index[Time.parse(val)]
      elsif val.is_a?(Fixnum)
        val
      else
        nil
      end
    end
  end
end

Dir[ File.join(File.dirname(__FILE__), 'setup/*.rb' )].each { |file| require file }