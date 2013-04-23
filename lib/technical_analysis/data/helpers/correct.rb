module TechnicalAnalysis::Data::Helpers
  def correct
    if !symbol.to_s.empty?
      sym = symbol
    elsif first.respond_to?(:symbol) and !first.symbol.to_s.empty?
      sym = first.symbol
    else
      raise 'Symbol not setted'
    end
    c = Company.where(symbol: sym).first
    return false if c.nil?
  end
end