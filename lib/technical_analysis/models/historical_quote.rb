class HistoricalQuote < ActiveRecord::Base
  attr_accessible :symbol, :period, :date, :open, :high, :low, :close, :volume, :operations

  include TechnicalAnalysis::Data::Helpers::Candle
end
