class HistoricalQuote < ActiveRecord::Base
  include TechnicalAnalysis::Data::Helpers::Candle
end
