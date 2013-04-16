module TechnicalAnalysis
  module RiskManagement
    autoload :Helpers, 'technical_analysis/risk_management/helpers'
  end
end

Dir[ File.join(File.dirname(__FILE__), 'risk_management/*.rb' )].each { |file| require file }