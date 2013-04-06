module TechnicalAnalysis::Data::LoadInterfaces
  module ClassMethods
    def load_from_csv(filename, options = {})
      s = self.new
      s.load_from_csv(filename, options)
      s
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
    self.sort! { |a,b| a.date <=> b.date }
  end
end