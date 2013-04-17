module TechnicalAnalysis::Data
  class Company < ActiveRecord
    attr_accessible :name, :symbol
    has_and_belong_to_many :portfolios, :class => 'TechnicalAnalysis::RiskManagement::Porfolio'
  end
end