module TechnicalAnalysis::Data::Helpers
  module ClassMethods
  end

  def high
    self.map { |i| i.high.to_f }
  end

  def low
    self.map { |i| i.low.to_f }
  end

  def close
    self.map { |i| i.close.to_f }
  end

  def open
    self.map { |i| i.open.to_f }
  end

  def volume
    self.map { |i| i.volume.to_f }
  end

  def datetime
    self.map { |i| i.datetime }
  end

  alias :time :datetime
  alias :date :datetime

end