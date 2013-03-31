module TechnicalAnalysis::Data
  class CandleArray < Array
    attr_accessor :period
    def <<(val)
      if val.is_a?(Hash)
        super(Candle.new(val))
      elsif val.is_a?(Array)
        super(Candle.new(*val))
      elsif val.is_a?(Candle)
        super(val)
      else
        raise ArgumentError.new('Candle parameters or Candle expected')
      end
    end

    def load_from_csv(filename, options = {})
      opt = { format: :first_line, period: :day, skip_first_line: false }.merge(options)

      raise ArgumentError.new("File not found #{File.expand_path(filename)}") unless File.exist?(filename)
      format      = opt[:format] if opt[:format].is_a?(Array)
      first_line  = true
      self.period = opt[:period]

      File.open(filename).readlines.each do |line|
        line = line.chomp
        next if line.empty?

        if first_line and opt[:skip_first_line]
          first_line = false
          next
        elsif first_line and opt[:format] == :first_line
          format = line.split(',').map { |i| i.downcase.to_sym }
          first_line = false
          next
        elsif first_line
          first_line = false
        end

        self << Hash[*format.zip(line.split(',')).flatten]
      end
    end
  end
end