class Quote < ActiveRecord::Base
  attr_accessible :symbol, :period, :date, :open, :high, :low, :close, :volume
  validates :symbol, uniqueness: { scope: [:date, :period], message: 'quote already exists' }

  include TechnicalAnalysis::Data::Helpers::Candle
end