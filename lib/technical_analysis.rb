require 'ffi/talib'
require "technical_analysis/version"
require 'time'
require 'yahoo_stock'

module TechnicalAnalysis
  autoload :Array, 'technical_analysis/ext/array'
  autoload :Data, 'technical_analysis/data'
  autoload :Analysis, 'technical_analysis/analysis'
  autoload :RiskManagement, 'technical_analysis/risk_management'
end

class Array
  include TechnicalAnalysis::Array
end