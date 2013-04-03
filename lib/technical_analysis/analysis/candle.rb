module TechnicalAnalysis::Analysis
  module Candle
  end
end

Dir[ File.join(File.dirname(__FILE__), 'candle/*.rb' )].each { |file| require file }