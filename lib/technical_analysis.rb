require 'ffi/talib'
require "technical_analysis/version"
require 'time'
require 'yahoo_stock'
require 'active_record'

ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yaml'))[ENV['RACK_ENV'] ||'development'])

module TechnicalAnalysis
  autoload :Array, 'technical_analysis/ext/array'
  autoload :Data, 'technical_analysis/data'
  autoload :Analysis, 'technical_analysis/analysis'
  autoload :RiskManagement, 'technical_analysis/risk_management'
end

autoload :Portfolio, 'technical_analysis/models/portfolio'
autoload :Company,   'technical_analysis/models/company'
autoload :ImportBovespa, 'technical_analysis/data/import_bovespa'
autoload :Movement,   'technical_analysis/models/movement'
autoload :Dividend,   'technical_analysis/models/dividend'
autoload :Quote, 'technical_analysis/models/quote'
autoload :HistoricalQuote, 'technical_analysis/models/historical_quote'
autoload :ImportBovespaCompanyInfo, 'technical_analysis/data/import_bovespa_company_info'

#autoload :Trade, 'technical_analysis/models/trade'


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