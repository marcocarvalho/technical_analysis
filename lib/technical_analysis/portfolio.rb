module TechnicalAnalysis
  class Porfolio < ActiveRecord
    attr_accessible :cash, :risk_management_type, :name
    has_and_belong_to_many :trade_with, :class => 'TechnicalAnalysis::Data::Company'
    autoload :Trade, 'technical_analysis/portfolio/trade'
  end
end