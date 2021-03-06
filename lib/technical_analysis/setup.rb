#
module TechnicalAnalysis
  class Setup
    attr_accessor :options, :candle_array, :riskmanagement
    include TechnicalAnalysis::Data::Helpers
    def self.inherited(klass)
      @klasses ||= []
      @klasses << klass
    end

    def self.list
      @klasses ||= []
    end

    def initialize(opts = {})
      @options        = opts
      @candle_array   = opts[:candle_array] || []
    end

    def price_near(price, opts = {})
      opts = { price_tolerance: 0.01 }.merge(opts)
      super(TechnicalAnalysis::Data::Candle.new(close: price), :close, opts)
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

    def minimal_ticks
      2
    end

    def minimal_ticks?
      candle_array.size >= minimal_ticks
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