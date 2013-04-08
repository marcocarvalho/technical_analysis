module TechnicalAnalysis::Analysis
  module Indicator
  end
end

Dir[ File.join(File.dirname(__FILE__), 'indicator/*.rb' )].each { |file| require file }