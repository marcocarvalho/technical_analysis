require 'ffi/talib'
require "technical_analysis/version"
require 'time'
require 'yahoo_stock'
require 'active_record'

ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yaml'))['development'])

module TechnicalAnalysis
  autoload :Array, 'technical_analysis/ext/array'
  autoload :Data, 'technical_analysis/data'
  autoload :Analysis, 'technical_analysis/analysis'
  autoload :RiskManagement, 'technical_analysis/risk_management'
end

class Array
  include TechnicalAnalysis::Array
end

module ActiveRecord
  class Relation
    include TechnicalAnalysis::Data::Helpers
    include TechnicalAnalysis::Analysis::Trend
    include TechnicalAnalysis::Analysis::Pattern
    include TechnicalAnalysis::Analysis::Indicator
  end
end