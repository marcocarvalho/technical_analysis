class Quote < ActiveRecord::Base
  validates :symbol, uniqueness: { scope: [:date, :period], message: 'quote already exists' }

  include TechnicalAnalysis::Data::Helpers::Candle
end
