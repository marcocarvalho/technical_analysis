module TechnicalAnalysis::Data
  class Candle
    class Quote < ActiveRecord::Base
      validates :symbol, uniqueness: { scope: [:date, :period], message: 'quote already exists' }
    end
  end
end