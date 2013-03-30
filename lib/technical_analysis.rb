require "technical_analysis/version"

module TechnicalAnalysis
  autoload :Array, 'technical_analysis/ext/array.rb'
  # Your code goes here...
end

Array.include(TechnicalAnalysis::Array)