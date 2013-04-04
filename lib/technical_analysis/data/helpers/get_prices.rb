module TechnicalAnalysis::Data::Helpers
  module ClassMethods
  end

  def high
    self.map { |i| i.high }
  end

  def low
    self.map { |i| i.low }
  end

  def close
    self.map { |i| i.close }
  end

  def open
    self.map { |i| i.open }
  end

  def volume
    self.map { |i| i.volume }
  end

  def datetime
    self.map { |i| i.datetime }
  end

  alias :time :datetime
  alias :date :datetime

end